class SocialInfos extends React.Component {
	constructor() {
		super();
		this.state = {
			uid:'',
			instagramId:'',
			twitterId:'',
			linkedin:'',
			website:'',
			avatarUrl:"/img/portrait700.jpg",
			step:'portfolio',
			error_messages:{},
			shootTypesMap:[],//Maps Opened Shoottype ids to shoottype titles

		};
		this.handleUidChange = this.handleUidChange.bind(this);
		this.handleInstagramIdChange=this.handleInstagramIdChange.bind(this);
		this.handleTwitterIdChange=this.handleTwitterIdChange.bind(this);
		this.handleLinkedinChange=this.handleLinkedinChange.bind(this);
		this.handleWebsiteChange=this.handleWebsiteChange.bind(this);
		this.handleAvatarUploadButton=this.handleAvatarUploadButton.bind(this);
		this.handleSubmitButton=this.handleSubmitButton.bind(this);
		this.handleInformationValidation=this.handleInformationValidation.bind(this);
		this.photoCountCheck=this.photoCountCheck.bind(this);
		this.initializeShootTypesMap=this.initializeShootTypesMap.bind(this);
		this.loadShootTypesMap=this.loadShootTypesMap.bind(this);
		this.getShootTypeTitleById=this.getShootTypeTitleById.bind(this);
	};
	componentDidMount(){
		if(this.props.loadData || this.props.loadUnCompletedData)
		{
			this.setState({uid:this.props.signedData.photographer.uid});
			this.setState({instagramId:this.props.signedData.photographer.instagram});
			this.setState({twitterId:this.props.signedData.photographer.twitter});
			this.setState({linkedin:this.props.signedData.photographer.online_portfolio});
			this.setState({website:this.props.signedData.photographer.linkedin});
			this.setState({avatarUrl:this.props.signedData.photographer.avatar});
			this.loadShootTypesMap();
			if (this.props.signedData.photographer.uid!==null) {
				this.setState({step:'photo'});
			}
		}
	}
	handleInformationValidation(){
		let formIsValid=true;

		$('#uid').parsley().validate();
		if($('#avatar_upload_preview').get(0).src.length==0)
		{
			$("#photoError").css('display', 'block');
        	$("#photoError p").text('لطفا عکس خود را بارگزاری نمایید' );
        	formIsValid = false;
		}
		if(!$('#uid').parsley().isValid() )
		{
            formIsValid = false;
        }
        if(formIsValid)
        {
        	$("#photoError").css('display', 'none');
        }

      	return formIsValid;
	}
	componentDidUpdate(prevProps,prevState){

		
		if(this.props.directToStep && prevProps.directToStep!==this.props.directToStep && this.props.directStep==2)
		{
			$('html, body').animate({scrollTop:$('#photo-upload').offset().top}, 'slow');
		}
	}
	
	handleSubmitButton()
	{
		if(this.state.step=="portfolio")
		{
			//console.log("this.state.step:(portfolio)");
			//console.log(this.state.step);
			this.initializeShootTypesMap();
			if(this.handleInformationValidation())
			{
				this.callPortfolioApi();
				
			}

		}
		else{
			//check all expertises more than 2
			if(this.photoCountCheck())
			{
				this.callPortfolioApi();//for step changing
				let data={};
				data['uid']=this.state.uid;

				this.props.socialInfosComponentFieldValuesCallBack(data);

			}


		}
	}
	handleAvatarUploadButton(event){
		$("#imgInp").trigger('click');
		$("#imgInp").on("change", (changeEvt)=> {
			this.setState({step:'portfolio'});
    		readURL(changeEvt.target);
	  	});
	}
	handleUidChange(event){
		this.setState({uid: event.target.value});
		this.setState({step:"portfolio"});
		$('#uid').parsley().validate();
	}
	handleInstagramIdChange(event){
		this.setState({instagramId: event.target.value});
		this.setState({step:"portfolio"});
	}
	handleTwitterIdChange(event){
		this.setState({twitterId: event.target.value});
		this.setState({step:"portfolio"});

	}
	handleLinkedinChange(event){
		this.setState({linkedin: event.target.value});
		this.setState({step:"portfolio"});

	}
	handleWebsiteChange(event){
		this.setState({website: event.target.value});
		this.setState({step:"portfolio"});

	}
	callPortfolioApi(){
		let error_messages={};
		let formData = new FormData();
		let photo = document.getElementById('imgInp').files[0];
		if($('#imgInp').get(0).files.length>0)
			formData.append('photographer[avatar]', photo);
		formData.append('photographer[uid]', this.state.uid);
		formData.append('photographer[instagram]', this.state.instagramId);
		formData.append('photographer[twitter]', this.state.twitterId);
		formData.append('photographer[online_portfolio]', this.state.website);
		formData.append('photographer[linkedin]', this.state.linkedin);
		formData.append('photographer[id]', this.props.photographerId);
		if(this.state.step=="portfolio")
		{
			formData.append('photographer[change_step]', 0);
		}
		else{
			formData.append('photographer[change_step]', 1);
		}

        let url=this.props.link+'/api/v1/photographers_portfolio';
        //console.log(this.props.token);
        return fetch(url, {method:'post',
            body: formData,
            headers: { "Accept":"application/json" ,"Authorization":this.props.token}})
             .then((response)=>{
            	if (parseInt(response.status) !== 200) {

            		response.json().then((object) =>{
            			//console.log("response errors:");
            			//console.log(object);
						error_messages["uid"] = object.errors.uid;
                		error_messages["photo"] = object.errors.photo;
						this.setState({error_messages: error_messages});

                		$('#submitPortfolioError').css('display', 'block');
                		//move up
                		$("html, body").animate({ scrollTop: 0 }, "slow");
    				});
            	}
                else{
					$('#submitPortfolioError').css('display', 'none');
                	response.json().then((object) =>{

						if(this.state.step=="portfolio")
						{
							this.setState({step:"photo"});
							let target = $('#photo-upload');
							scrollToId(target);
							
						}
						else{
							this.props.nextStep();
						}
                        //console.log(object.photographer.token);
                        //console.log(object.photographer.id);
    				});

                }



            })
            .catch(function(e){console.log(e)});
	}
	loadShootTypesMap(){
		let shootTypes=[];
		for (var i = 0; i < this.props.signedData.shoot_types.length; i++) {
	        let newShootType={id:this.props.signedData.shoot_types[i].id,title:this.props.signedData.shoot_types[i].title};
			shootTypes.push(newShootType);

    	}
    	this.setState({
				shootTypesMap: shootTypes
		});
	}
	initializeShootTypesMap(){
		let shootTypes=[];
		for (var i = 0; i < this.props.shootTypes.length; i++) {
	        let newShootType={id:this.props.shootTypes[i].id,title:this.props.shootTypes[i].title};
			shootTypes.push(newShootType);

    	}
    	this.setState({
				shootTypesMap: shootTypes
		});

	}
	getShootTypeTitleById(id){
		//console.log("getShootTypeTitleById shootTypesMap length:"+this.state.shootTypesMap.length);
		for (var i = 0; i < this.state.shootTypesMap.length; i++) {

			if(this.state.shootTypesMap[i].id==id)
			{
				return this.state.shootTypesMap[i].title;
			}
		}
	}
	photoCountCheck(){
		let photoCountCheck=true;
		let error_messages=[];
		$("#photoCheckError").css('display', 'none');
		$("#photoCheckError ul").empty();
		// if we have no photo upload tables
		if($(".table.table-hover .files").length==0){
			photoCountCheck=false;
			$("#photoCheckError").css('display', 'block');
			error_messages.push('هیچ عکسی آپلود نکرده اید');

		}

		$(".table.table-hover .files").each((index, element)=>{
	      //console.log(element);
	      //console.log(element.childElementCount);
	      //console.log(element.parentNode.id);
	      if(element.childElementCount<6)
	      {
	      	let title=this.getShootTypeTitleById(element.parentNode.id);
	      	photoCountCheck=false;
	      	$("#photoCheckError").css('display', 'block');
	      	//console.log('تعداد عکس های رشته ی ' +title+' کم تر از ۳ عدد می باشد');
	      	error_messages.push('تعداد عکس های رشته ی ' +title+' کم تر از ۶ عدد می باشد');
	      }


	    });
	    if(photoCountCheck){
	    	$("#photoCheckError").css('display', 'none');
	    }
	    else{
	    	if(error_messages.length>0){
		      	for (var i = 0; i<error_messages.length ; i++) {
		      		$("#photoCheckError ul").append('<li><p id="errors">'+error_messages[i]+'</p></li>');
		      	}
			}
	    	var target = $('#photoCheckError');
	    	scrollToId(target);
	    }
	    return photoCountCheck;
	}
	render () {
		return (
			<React.Fragment>
				<section id="main">
					<div className="container">
						<div className="main">
							<div className="tracker">
								<div className="process-tabs-line w-hidden-tiny">
									<span className="step-line step-line-package active" style={{width: "33.3333%" ,right: "0%"}}></span>
									<span className="step-line step-line-datetime active" style={{width: '33.3333%', right: '33.3333%'}}></span>
									<span className="step-line step-line-details" style={{width:'33.3333%',right: '66.6667%'}}></span>
								</div>
								<div className="process-tab-button tracker-circle selected" style={{right: '0%'}}>
									<div className="tracker-text">
									اطلاعات اولیه
									</div>
								</div>
								<div className="process-tab-button tracker-circle selected " style={{right: '33.3333%'}}>
									<div className="tracker-text">
									تجهیزات عکاسی
									</div>
								</div>
								<div className="process-tab-button tracker-circle selected" style={{right: '66.6667%'}}>
									<div className="tracker-text">
									نمونه کارها
									</div>
								</div>
								<div className="process-tab-button tracker-circle" style={{right: '100%'}}>
									<div className="tracker-text">
									تجربه کاری
									</div>
								</div>
							</div>
							<div className="wrapper">
								<div className="row" style={{marginBottom: '30px'}}>
									<div className="col-sm-12">
										<p className="text-center">
										بهترین نمونه عکس های تان را آپلود کنید،
										<br />
										تا
										مشتریان
										با سبک و سلیقه کاری شما آشنا شوند.
										<br />
										آپلود عکس های غیر تکراری برای ارزیابی شما مفیدتر می باشد.
										<br />
										<small>
										(
										عکس ها در صفحه شما نمایش داده خواهند شد
										)
										</small>
										</p>
										<hr />
										<div className="alert alert-danger" id="submitPortfolioError" style={{ display: "none"}}>
											<p id="errors">{this.state.error_messages["uid"]}</p>
											<p id="errors">{this.state.error_messages["photo"]}</p>
										</div>
									</div>
									<input type='file' id="imgInp" required style={{ display: "none"}}/>
									<div className="col-sm-6">
										<div className="col-sm-12">
											<h5 style={{lineHeight: '25px'}}>
												عکس پرتره حرفه ای از خودتان
												<span style={{color:'red'}}>
												{" * "}
												</span>
												<small className="text-muted my-alert" style={{fontSize: '15px'}}>
												عکس باید فقط به فرمت
											 	jpeg
											 	و ابعاد
												700px در 700px باشد.
												</small>
											</h5>
											<div className="col-sm-9 text-center well">
												<img id="avatar_upload_preview" src={this.state.avatarUrl} alt="your image" className="img-reponsive " />
											</div>
											<div className="col-sm-3">
												<div className="btn btn-blue" id="profile-pic" onClick={this.handleAvatarUploadButton}>
												انتخاب
												</div>

											</div>

										</div>
										<div className="col-sm-12" id="photoError" style={{ display: "none"}}>
											<p style={{ color: "red" ,textDecoration: 'none' }}>

											</p>
										</div>
										<div className="col-sm-12">
									    	<h5>
									    		<img src="/img/favicon.png" alt="کادرو" className="img-reponsive" style={{ width: '27px',display: 'inline-block'}} />

												{' یک آی دی برای صفحه خود انتخاب کنید:'}
												<span style={{color:'red'}}>
												{'  * '}
												</span>
												<small className="pull-left" >
												به عنوان مثال:
													<span style={{fontSize: '15px'}}>
													<a target="blank" href="http://sample.kadro.co/">sample.kadro.co</a>
													{/*<%=link_to "sample.kadro.co","http://sample.kadro.co/" , target: :blank %>*/}
													</span>
												</small>

											</h5>
											<div className="input-group" style={{marginTop: '4%'}}>
												<span className="input-group-addon" style={{fontSize:'20px'}} > kadro.co. </span>
												{/*<%= f.text_field "uid" , class: "form-control text-center ltr mytextbox" , 'required' => "",  'aria-describedby'=> "uid" ,placeholder: "فقط یک نام یکتا وارد کنید" %>*/}
												<input className="form-control text-center ltr mytextbox"
												 id="uid" aria-describedby="uid" placeholder="فقط یک نام یکتا وارد کنید"  type="text"
												 required
												 value={this.state.uid} onChange={this.handleUidChange}
												 data-parsley-pattern="^[a-z_]+[a-z0-9_]*$"
												 data-parsley-pattern-message="این مقدار مورد قبول نمی باشد (غیر از حروف انگلیسی کوچک و عدد و '_' مورد قبول نیست و حرف شروع نباید عدد باشد)"
												 />
											</div>
										</div>

									</div>
									<div className="col-sm-6">
										<div className="col-sm-12 left">
											<h5>
											<img src="/img/instagram.png" alt="instagram" className="img-reponsive" style={{ width: '27px',display: 'inline-block'}} />
											{'  آی دی اینستاگرام شما'}
											</h5>
											<div className="input-group">
												{/*<%= f.text_field "instagram" , class: "form-control ltr",  'aria-describedby'=> "instagram" ,placeholder: "فقط آی دی را وارد کنید" %>*/}

												<input className="form-control ltr" aria-describedby="instagram" placeholder="فقط آی دی را وارد کنید" type="text"
												value={this.state.instagramId} onChange={this.handleInstagramIdChange}
												 />
												<span className="input-group-addon" style={{fontSize:'20px'}} id="instagram">/https://instagram.com</span>
											</div>

										</div>
										<div className="col-sm-12 left">
											<h5>
											<img src="/img/twitter.png" alt="twitter" className="img-reponsive" style={{ width: '27px',display: 'inline-block'}} />
											{'  آی دی توییتر شما'}
											</h5>
											{/*<%#= f.text_field "twitter" , class: "form-control ltr"%>*/}
											<div className="input-group">
												{/*<%= f.text_field "twitter" , class: "form-control ltr",  'aria-describedby'=> "twitter" ,placeholder: "فقط آی دی را وارد کنید" %>*/}
												<input className="form-control ltr" aria-describedby="twitter" placeholder="فقط آی دی را وارد کنید" type="text"
												value={this.state.twitterId} onChange={this.handleTwitterIdChange}
												 />
												<span className="input-group-addon" style={{fontSize:'20px'}} id="instagram">/https://twitter.com</span>
											</div>
										</div>
										<div className="col-sm-12 left">
											<h5>
											<img src="/img/linkedin.png" alt="linkedin" className="img-reponsive" style={{ width: '27px',display: 'inline-block'}} />
											{'  لینک صفحه لینکداین شما'}
											</h5>
											{/*<%= f.text_field "linkedin" , class: "form-control ltr" ,placeholder: "https://www.linkedin.com/in/"%>*/}
											<input className="form-control ltr" type="text" placeholder="https://www.linkedin.com/in/"
											value={this.state.linkedin} onChange={this.handleLinkedinChange}
											/>
										</div>
										<div className="col-sm-12">
											<h5>
											<img src="/img/web.png" alt="instagram" className="img-reponsive" style={{ width: '27px',display: 'inline-block'}} />
											{' وب سایت شخصی'}
											</h5>
											<input className="form-control ltr" type="text" placeholder="www.example.com"
											value={this.state.website} onChange={this.handleWebsiteChange}/>

											{/*<%= f.text_field "online_portfolio" , class: "form-control ltr" ,placeholder: "www.example.com"%>*/}
										</div>
									</div>
								</div>
								<hr />
								<PhotoUpload
								step={this.state.step}
								shootTypes={this.props.shootTypes}
								shootTypesLength={this.props.shootTypesLength}
								photographerId={this.props.photographerId}
								loadData={(this.props.loadData||this.props.loadUnCompletedData)?true:false}
								deactiveLoadDataCallBack={(Id) => this.setState({loadEquipment:Id})}
								signedExpertises={this.props.signedData.photographer_expertises}
								link={this.props.link}
								token={this.props.token}
								/>
							</div>{/*<!-- /.wrapper -->*/}
						</div>{/*<!-- /.main -->*/}

					</div>{/*<!-- /.container -->*/}
				</section>{/*<!-- /.main -->*/}
				<footer id="footer">
				  <div className="container">
				    <div className="wrap">
				      <a className="btn btn-gray"  onClick={this.props.previousStep}> بازگشت </a>
				      <button type="submit" id ="submit_page_form" className="btn btn-blue" onClick={this.handleSubmitButton} >ذخیره و ادامه
				      </button>
				    </div>
				  </div>
				</footer>
			</React.Fragment>
		);
	}
}
