class Info extends React.Component {
	constructor() {
		super();
		this.state = {
			error_messages:{},
			infoCompleted:false,
			continueEnabled:false,
			emailAddress:'',
			lastName:'',
			mobileNumber:'',
			staticNumber:'',
			firstName:'',
			password:'',
			idealHours:'',
			parentId:'',
			token:'',
			photographerId:-1,
			livingAddress:'',
			workingLat:-1,
			workingLng:-1,
			workingAddress:'',
			checkOneSelected:false,
			checkTwoSelected:false,
			passwordChanged:false,
			wait:false,
		
		};
		
		this.handleEmailChange = this.handleEmailChange.bind(this);
		this.handleLastNameChange = this.handleLastNameChange.bind(this);
        this.handleMobileNumberChange = this.handleMobileNumberChange.bind(this);
        this.handleFirstNameChange = this.handleFirstNameChange.bind(this);
        this.handleStaticNumberChange= this.handleStaticNumberChange.bind(this);
        this.handlePasswordChange= this.handlePasswordChange.bind(this);
        this.handleIdealHoursChange= this.handleIdealHoursChange.bind(this);
        this.handleParentIdChange= this.handleParentIdChange.bind(this);

    	this.handleSubmitButton = this.handleSubmitButton.bind(this);
        this.handleInformationValidation=this.handleInformationValidation.bind(this);
        this.callPhotographersApi=this.callPhotographersApi.bind(this);
        this.submitLocation=this.submitLocation.bind(this);
		this.handleCheckOneSelectedChange=this.handleCheckOneSelectedChange.bind(this);
		this.handleCheckTwoSelectedChange=this.handleCheckTwoSelectedChange.bind(this);
    }
    componentDidMount(){
    	if(this.props.loadInfo || this.props.loadLocation){
    		this.setState({firstName:this.props.infoData.first_name});
    		this.setState({lastName:this.props.infoData.last_name});
    		this.setState({email:this.props.infoData.email});
    		this.setState({mobileNumber:this.props.infoData.mobile_number});
    		this.setState({staticNumber:this.props.infoData.static_number});
    		this.setState({idealHours:this.props.infoData.ideal_hours});
    		this.setState({emailAddress:this.props.infoData.email});
    		this.setState({password:this.props.infoData.password});
    		this.setState({parentId:this.props.infoData.parent_id});
    		this.setState({token:this.props.infoData.token});
    		this.setState({photographerId:this.props.infoData.id});
    		this.setState({checkOneSelected:true});
    		this.setState({checkTwoSelected:true});
    		this.setState({infoCompleted:true});
    		this.setState({continueEnabled:true});
    		
    	}
    	if(this.props.loadLocation)
    	{
    		this.setState({workingLat:this.props.locationData.working_lat});
    		this.setState({workingLng:this.props.locationData.working_long});
    		this.setState({workingAddress:this.props.locationData.living_input});
    		this.setState({livingAddress:this.props.locationData.living_address});
    	}
    	//block typing other than numbers

		$('[data-toggle="why_static_number"]').tooltip({
			title: "کادرو برای احراز هویت عکاسان با شماره ثابتی که می دهند تماس می گیرد و مصاحبه تلفنی کوتاهی از این طریق انجام می دهد."
	    });
	    $('[data-toggle="why_mobile_number"]').tooltip({
			title: "کادرو پروژه های جدید عکاسی را از طریق پیامک به شما اطلاع می دهد و یا در صورت وجود مشکل یا تغییری در برنامه به شما زنگ می زند."
	    });
	}
	handleCheckOneSelectedChange(event){

    	this.setState({checkOneSelected:event.target.checked},()=>{
    		if(this.state.checkOneSelected && this.state.checkTwoSelected)
			{

				this.setState({continueEnabled:true});
			}
			else
			{
				this.setState({continueEnabled:false});
			}
    	});
    	

    }
    handleCheckTwoSelectedChange(event){

    	this.setState({checkTwoSelected:event.target.checked},()=>{
    		if(this.state.checkOneSelected && this.state.checkTwoSelected)
			{
				//console.log("continueEnabled ");
				this.setState({continueEnabled:true});
			}
			else
			{
				this.setState({continueEnabled:false});
			}
    	});
    	
    	
    }
    handleEmailChange(event){
        this.setState({emailAddress: event.target.value});
        this.setState({infoCompleted: false});

    }
    handleLastNameChange(event){
        this.setState({lastName: event.target.value});
        $('#last_name').parsley().validate();
        this.setState({infoCompleted: false});
    
    }
    handleMobileNumberChange(event){
    	let englishMobileNum=event.target.value.toEnglishDigits();
        this.setState({mobileNumber: englishMobileNum});
        this.setState({infoCompleted: false});

    }
    handleFirstNameChange(event){
        this.setState({firstName: event.target.value});
        $('#first_name').parsley().validate();
        this.setState({infoCompleted: false});

    }
    handleStaticNumberChange(event){
    	let englishTelNum=event.target.value.toEnglishDigits();
    	this.setState({staticNumber: englishTelNum});
        this.setState({infoCompleted: false});
    }
    handlePasswordChange(event){
    	this.setState({passwordChanged:true});
    	this.setState({password: event.target.value});
        this.setState({infoCompleted: false});
    }
    handleIdealHoursChange(event){
    	this.setState({idealHours: event.target.value});
        this.setState({infoCompleted: false});
    }
    handleParentIdChange(event){
    	this.setState({parentId: event.target.value});
    	$('#parent_id').parsley().validate();
        this.setState({infoCompleted: false});
    }
	handleInformationValidation(){
		let formIsValid=true;
        $('#last_name').parsley().validate();
		$('#first_name').parsley().validate();
		if((this.state.passwordChanged && this.props.loadInfo) || !this.props.loadInfo)//if user has signed up first time or user has edited his pass
		{	
			$('#password').parsley().validate();
		}
		$('#ideal_hours').parsley().validate();
        $('#mobile_number').parsley().validate();
        $('#static_number').parsley().validate();
        $('#email').parsley().validate();
        $('#parent_id').parsley().validate();
	    if ((this.state.passwordChanged && this.props.loadInfo) || !this.props.loadInfo) {
	        if(
	        	!$('#first_name').parsley().isValid() ||
				!$('#last_name').parsley().isValid() || 
	        	!$('#mobile_number').parsley().isValid() || 
	        	!$('#static_number').parsley().isValid()|| 
	        	!$('#email').parsley().isValid()||
	        	!$('#password').parsley().isValid()||
	        	!$('#ideal_hours').parsley().isValid()||
	        	!$('#parent_id').parsley().isValid()
	        )
        	{
	            formIsValid = false;
	        }
	    }
	    else
	    {
	    	if(
	        	!$('#first_name').parsley().isValid() ||
				!$('#last_name').parsley().isValid() || 
	        	!$('#mobile_number').parsley().isValid() || 
	        	!$('#static_number').parsley().isValid()|| 
	        	!$('#email').parsley().isValid()||
	        	!$('#ideal_hours').parsley().isValid()
	        )
        	{
	            formIsValid = false;
	        }
	    }
		
      	return formIsValid;
    }
	handleSubmitButton(){

		if(!this.state.infoCompleted )	
		{
		
			if(this.handleInformationValidation())
			{
				$('#submitInfoError').css('display', 'none');
				this.callPhotographersApi();
			}
			else{
				$('#submitInfoError').css('display', 'block');
				var target = $("#submitInfoError");
				scrollToId(target);
			}

			//make reset address inputs when infos are changed and photographer id is changed
			//myMap();
		}
		else{

			$('#working_address').parsley().validate();
			$('#living_address').parsley().validate();
			if($('#working_address').parsley().isValid() && $('#living_address').parsley().isValid())
			{
				
				this.submitLocation();
				
			}
			else if(!$('#working_address').parsley().isValid()){
				var target = $('#working_address');
				scrollToId(target);
			}
			else{
				var target = $('#living_address');
				scrollToId(target);
			}
		}
		
	}
	submitLocation(){
		let lenzEquipments=[];
		let cameraEquipments=[];
		let kitEquipments=[];
		this.setState({wait:true});
		$.ajax({
		 url: "https://api.neshan.org/v2/reverse?lat="+this.state.workingLat+"&lng="+this.state.workingLng,
		 type: "GET",
		 beforeSend: function(xhr){xhr.setRequestHeader('Api-Key', 'service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X');},
		 success: (res)=> {
		 	let workingInput = res.formatted_address;
		 	let data={
				location:{
					living_address:this.state.livingAddress,
					living_long:this.state.workingLng,
					living_lat:this.state.workingLat,
					working_long:this.state.workingLng,
					working_lat:this.state.workingLat,
					living_input:workingInput,
					working_input:workingInput, 
					photographer_id:this.state.photographerId
				}
			};
			let body = JSON.stringify(data);
	        let url=this.props.link+'/api/v1/locations';
	        return fetch(url, {method:'post',
	            body: body,
	            headers: { "Content-Type": "application/json","Accept":"application/json"  ,"Authorization":this.state.token }})
	            .then((response)=>{
	            	if (parseInt(response.status) !== 200) {

	            		response.json().then((object) =>{

	                		//move up
	    				});
	            	}
	                else{
	                	
	                	response.json().then((object) =>{
	                		//console.log(object);
	                		
							object['data'].map((item) =>{                			
		                		if(item.type=="lenz")
	            				{

	            					lenzEquipments.push(item);
	            				}
	            				else if(item.type=="kit")
	            				{
	            					kitEquipments.push(item);
	            				}
	            				else{
	            					cameraEquipments.push(item);
	            				}
	            			});
	            			//preparing for sending info component information to other components
							var data = {}
							data['token']=this.state.token;
			        		data['photographerId']=this.state.photographerId;
			        		data['firstName']=this.state.firstName;
			        		data['lastName']=this.state.lastName;
			        		//preparing for sending info component information to other components
			        		this.props.kitEquipmentCallBack(kitEquipments);
			        		this.props.lenzEquipmentCallBack(lenzEquipments);
			        		this.props.cameraEquipmentCallBack(cameraEquipments);
							this.props.infoComponentFieldValuesCallBack(data);
							this.setState({wait:false});
							this.props.nextStep();

	    				});
	                    
	                }
	            
	            	
	            })
	            .catch(function(e){console.log(e)});
			}
		});

	}
	callPhotographersApi(){

		let error_messages={};
		{/*let data={
			photographer:{
				first_name:"پیمان",
				last_name:"زینلی",
				mobile_number:"07446323358",
				email:"peydsa@gmail.com",
				static_number:"0215570983",
				password:"12332134",
				ideal_hours:"20" , 
				parent_id:"kimiasb"
			}
		};*/}
		
		
		let data={};
		if(!this.props.loadInfo && this.state.photographerId==-1)//signup
		{

			data={
				photographer:{
					first_name:this.state.firstName,
					last_name:this.state.lastName,
					mobile_number:this.state.mobileNumber,
					email:this.state.emailAddress,
					static_number:this.state.staticNumber,
					password:this.state.password,
					ideal_hours:this.state.idealHours,
					parent_id:this.state.parentId
				}
			};
		}
		else if(!this.props.loadInfo && this.state.photographerId!==-1)
		{
			data={
				photographer:{
					first_name:this.state.firstName,
					last_name:this.state.lastName,
					mobile_number:this.state.mobileNumber,
					email:this.state.emailAddress,
					static_number:this.state.staticNumber,
					password:this.state.password,
					ideal_hours:this.state.idealHours,
					parent_id:this.state.parentId,
					id:this.state.photographerId
				}
			};
		}
		else if(this.state.passwordChanged)//&& this.props.loadInfo==true && definitely we have photographerId
		{
			data={
				photographer:{
					first_name:this.state.firstName,
					last_name:this.state.lastName,
					mobile_number:this.state.mobileNumber,
					email:this.state.emailAddress,
					static_number:this.state.staticNumber,
					password:this.state.password,
					ideal_hours:this.state.idealHours,
					parent_id:this.state.parentId,
					id:this.state.photographerId
				}
			};
			this.setState({passwordChanged:false});//reset changed password situation
		}
		else{//this.state.passwordChanged==false && this.props.loadInfo==true && definitely we have photographerId

			data={
				photographer:{
					first_name:this.state.firstName,
					last_name:this.state.lastName,
					mobile_number:this.state.mobileNumber,
					email:this.state.emailAddress,
					static_number:this.state.staticNumber,
					ideal_hours:this.state.idealHours ,
					parent_id:this.state.parentId,
					id:this.state.photographerId
				}
			};
		}
		
		///make submit button disabled before call api for disabling user click submit twice
		this.setState({continueEnabled:false});

		let body = JSON.stringify(data);
        let url=this.props.link+'/api/v1/photographers';
        //console.log(body);
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/json","Accept":"application/json" }})
            .then((response)=>{
            	if (parseInt(response.status) !== 200) {

            		response.json().then((object) =>{
            			this.setState({continueEnabled:true});
                		error_messages["email"] = object.errors.email;
                		error_messages["mobile_number"] = object.errors.mobile_number;
                		this.setState({error_messages: error_messages}); 
                		//move up
                		var target = $("#submitServerInfoError");
                		target.css('display', 'block');
						scrollToId(target);

    				});
            	}
                else{
					
            		$('#submitServerInfoError').css('display', 'none');
                	response.json().then((object) =>{
                		this.setState({continueEnabled:true});
                		this.setState({infoCompleted: true});
                		this.setState({token:object.photographer.token});
                		this.setState({photographerId:object.photographer.id});
    				});
                    
                }
     
            	
            	
            })
            .catch(function(e){console.log(e)});
	}
	render () {

		let returnLink;
		if(this.props.loadInfo>0)//if user has signed in
		{
			returnLink=<a className="btn btn-gray" href="/photographers/sign_out"> خروج </a>;
		}
		else{
			returnLink=<a className="btn btn-gray" disabled> بازگشت </a>;
		}
		return (
			<React.Fragment>
				<section id="main">
					<div className="container">
						<div className="main">
							<div className="tracker">
								<div className="process-tabs-line w-hidden-tiny">
									<span className="step-line step-line-package" style={{width: "33.3333%" ,right: "0%"}}></span>
									<span className="step-line step-line-datetime" style={{width: '33.3333%', right: '33.3333%'}}></span>
									<span className="step-line step-line-details" style={{width: '33.3333%' , right: '66.6667%'}}></span>
								</div>
								<div className="process-tab-button tracker-circle selected" style={{right: '0%'}}>
									<div className="tracker-text">
									اطلاعات اولیه
									</div>
								</div>
								<div className="process-tab-button tracker-circle " style={{right: '33.3333%'}}>
									<div className="tracker-text">
									تجهیزات عکاسی
									</div>
								</div>
								<div className="process-tab-button tracker-circle" style={{right: '66.6667%'}}>
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
									<div className="col-sm-6">
										<div className="col-sm-12 text-right text-muted">برای راحتی کار با مرورگر دسکتاپ شروع کنید.</div>
										<div className="col-sm-12 text-right text-muted" style={{marginTop: '1%'}}>

											<span className="my-alert">توجه:</span> ورودی های <span className="my-alert">{' ستاره '}</span> دار الزامی می‌باشند.
										</div>
										<div className="col-sm-12" style={{marginTop: '3%'}}>
											{/*<div className="text-right text-muted">
												برای راحتی کار با مرورگر دسکتاپ شروع کنید.
											</div>*/}

											<div className="alert alert-danger" id="submitInfoError" style={{ display: "none"}}>
												<p id="errors">تمامی موارد ستاره دار باید پر شوند</p>
											</div>
											<div className="alert alert-danger" id="submitServerInfoError" style={{ display: "none"}}>
												<p id="errors">{this.state.error_messages["mobile_number"]}</p>
  												<p id="errors">{this.state.error_messages["email"]}</p>
  												<a href={(this.props.link)+"/photographers/sign_in"}>از اینجا می توانید وارد شوید</a>
											</div>
											<label htmlFor="first_name"><span style={{color:'red'}}>*</span> نام شما</label>
											{/*-- trying to run parsley on form submition #*/}
											<input className="form-control mytextbox" required type="text" id="first_name" placeholder="" 
											value={this.state.firstName} onChange={this.handleFirstNameChange} data-parsley-pattern="^[آ-ی\s]*$" data-parsley-pattern-message="این مقدار باید حروف فارسی باشد"/>
											{/*#= f.text_field :first_name , placeholder: "نام شما" , className: "form-control" , name: "name" , id: "name", :requried => "" */}
										</div>
										<div className="col-sm-12"style={{marginTop: '3%'}}>
											<label htmlFor="last_name"><span style={{color:'red'}}>*</span> نام خانوادگی تون </label>
											<input className="form-control mytextbox" required type="text" id="last_name"  placeholder=""  
											value={this.state.lastName} onChange={this.handleLastNameChange} data-parsley-pattern="^[آ-ی\s]*$" data-parsley-pattern-message="این مقدار باید حروف فارسی باشد"/>
										</div>
										<div className="col-sm-12" style={{marginTop: '3%'}}>
											<label htmlFor="mobile_number"><span style={{color:'red'}}>*</span> شماره موبایل تون</label>
											<input className="form-control" required type="tel" style={{direction: 'ltr', textAlign: 'right'}} name="photographer[mobile_number]" id="mobile_number" placeholder=""  
											value={this.state.mobileNumber} onChange={this.handleMobileNumberChange} data-parsley-pattern="^(\+98|0)?9\d{9}$"

											data-parsley-pattern-message="این مقدار باید شماره موبایل معتبر باشد"/>
										</div>
										<div className="text-center col-sm-12" style={{marginTop: '5px',marginBottom: '5px'}}>
											<span data-html="true" className="text-muted" style={{fontSize: '11px',fontStyle: 'italic'}} data-toggle="why_mobile_number" data-placement="top" >
												<img src="/img/information.png" alt="" style={{width: '30px'}} />
												چرا شماره موبایل نیاز است؟
											</span>
										</div>
										<div className="col-sm-12" style={{marginTop: '3%'}}>
											<label htmlFor="static_number"><span style={{color:'red'}}>*</span> شماره تلفن ثابت با کد شهر</label>
											<input className="form-control" required  id="static_number" placeholder="مثال : 02128425220" type="tel"
											value={this.state.staticNumber} onChange={this.handleStaticNumberChange} data-parsley-pattern="^(?:\(\d{3}\)|\d{3})[- ]?\d{3}[- ]?\d{5}$"
											data-parsley-pattern-message="این مقدار باید شماره تلفن معتبر باشد"/>
										</div>
										<div className="text-center col-sm-12" style={{marginTop: '5px',marginBottom: '5px'}}>
											<span data-html="true" className="text-muted" style={{fontSize: '11px', fontStyle: 'italic'}} data-toggle="why_static_number" data-placement="top" >
												<img src="/img/information.png" alt="" style={{width: '30px'}} />
												چرا شماره تلفن ثابت نیاز است؟
											</span>
										</div>
										<div className="col-sm-12" style={{marginTop: '3%'}}>
											<label htmlFor="email"><span style={{color:'red'}}>*</span> ایمیل شما</label>
											<input className="form-control" required type="email" name="photographer[email]" id="email" placeholder=""
											value={this.state.emailAddress} onChange={this.handleEmailChange} />
										</div>
										<div className="col-sm-12" style={{marginTop: '6%'}}>
											<label htmlFor="password"><span style={{color:'red'}}>*</span> رمز عبور جدید</label>
											<input className="form-control" required type="password" name="photographer[password]" id="password" placeholder="حداقل ۶ حرف" 
											value={this.state.password} onChange={this.handlePasswordChange} autoComplete="new-password" data-parsley-minlength='6'
											 />
										</div>
										<div className="col-sm-12" style={{marginTop: '6%'}}>
											<label htmlFor="ideal_hours"><span style={{color:'red'}}>*</span> چند ساعت در هفته علاقه به کار با کادرو دارید؟</label>
											<input className="form-control" required type="number" name="photographer[ideal_hours]" id="ideal_hours" placeholder=""
											value={this.state.idealHours} onChange={this.handleIdealHoursChange} />
										</div>
										
									</div>
									<div className="col-sm-6 hidden-xs">
										<div className="col-sm-12" style={{marginTop: '9%'}}>
											<img src={(this.props.link)+"/assets/become_kadro-7edccc7bdd9592ac865a78424c4d22eeddaa7854974db58de8224f012a10e37d.jpg"} />
										</div>
									</div>
									<div className="col-sm-6" style={{marginTop: '3%'}}>
										<div className="col-sm-12" style={{marginTop: '3%'}}>
											<label htmlFor="parent_id">
											اگر عکاسی کادرو را به شما معرفی کرده است:
											</label>
											<input className="form-control" type="text" name="photographer[parent_id]" id="parent_id" placeholder="شناسه آن عکاس وارد نمایید."
											data-parsley-pattern="^[a-z_]+[a-z0-9_]*$"
										 	data-parsley-pattern-message="آی دی معرف تان را درست وارد نکرده اید"
											value={this.state.parentId} onChange={this.handleParentIdChange} />
										</div>
									</div>
									
								</div>
								<div className="row">
									<div className="col-sm-6">
											
											<div className="form-group" style={{marginTop: '30px'}}>
												<div className="checkbox-control">
													<input 
													type="checkbox" 
													id="check1" 
													value="انتخاب توافق" 
													checked={this.state.checkOneSelected}
													onChange={this.handleCheckOneSelectedChange} 
													/>
													<label htmlFor="check1">
													{'من ' 	}
													<a id="checkout" href="https://kadro.co/terms/" target="_blank">
													 شرایط و مقررات 
													</a>
													{' کادرو را خوانده و پذیرفته ام.'}
													
													</label>
												</div>
												<div className="checkbox-control">
													<input 
													type="checkbox" 
													id="check2" 
													value="قوانین" 
												
													checked={this.state.checkTwoSelected}
													onChange={this.handleCheckTwoSelectedChange}
													 />
													<label htmlFor="check2">
													من تصدیق می کنم تمامی اطلاعات وارد شده مربوط به اینجانب می باشد.
													</label>
												</div>
											</div>
											
										</div>
								</div>
								<Address 
									infoCompleted={this.state.infoCompleted}
									loadLocation={this.props.loadLocation}
									locationData={this.props.locationData}
									livingAddressCallback={(id) => this.setState({livingAddress:id})}
									workingAddressCallback={(id) => this.setState({workingAddress:id})}
									workingLatCallback={(id) => this.setState({workingLat:id})}
									workingLngCallback={(id) => this.setState({workingLng:id})}
								/>
							</div>
						</div>
					</div>
				</section>
				<footer id="footer">
					<div className="container">
						<div className="wrap">
							{returnLink}
							<button type="submit" id="submit_page_form" className="btn btn-blue" onClick={this.handleSubmitButton} disabled={!(this.state.continueEnabled)} >ذخیره و ادامه
							</button>
						</div>
					</div>
				</footer>
				<WaitingPopup wait={this.state.wait}/>
			</React.Fragment>
		);
	}
}

