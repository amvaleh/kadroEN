class Experiences extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			hasPayedWork:false,
			yearsBeenPhotographer:0,
			projectsPayedCount:null,
			selfDescribe:null,
			bio:null,
			passion:null,
			loveJob: null,
			favoriteShoots:null,
			shoots:null,
			cityShoots:null,
			awards:null,
			funFact:null,	
		};
		this.handleYearsBeenPhotographerChange=this.handleYearsBeenPhotographerChange.bind(this);
		this.handleProjectsPayedCountChange=this.handleProjectsPayedCountChange.bind(this);
		this.handleSelfDescribeChange=this.handleSelfDescribeChange.bind(this);
		this.handleBioChange=this.handleBioChange.bind(this);
		this.handlePassionChange=this.handlePassionChange.bind(this);
		this.handleLoveJobChange=this.handleLoveJobChange.bind(this);
		this.handleFavoriteShootsChange=this.handleFavoriteShootsChange.bind(this);
		this.handleShootsChange=this.handleShootsChange.bind(this);
		this.handleCityShootsChange=this.handleCityShootsChange.bind(this);
		this.handleAwardsChange=this.handleAwardsChange.bind(this);
		this.handleFunFactChange=this.handleFunFactChange.bind(this);
		this.handleSubmitButton=this.handleSubmitButton.bind(this);
		this.callExperienceApi=this.callExperienceApi.bind(this)
		this.handlePayedWorkClick=this.handlePayedWorkClick.bind(this);
		this.handleNotPayedWorkClick=this.handleNotPayedWorkClick.bind(this);
		this.handleInformationValidation=this.handleInformationValidation.bind(this);
		this.onBlur=this.onBlur.bind(this);
		this.inputChanged=[],
		this.inputNames=["self_describe","bio","passion","love_job","favorite_shoots","shoots","city_shoots","awards","fun_fact"]
	};
	componentDidMount(){
		for (let index = 0; index < 9; index++) {
			this.inputChanged[this.inputNames[index]] =false;
		}

	}
	componentDidUpdate(prevProps,prevState) {
		
		if(prevProps.loadData!==this.props.loadData && this.props.loadData)
		{
			this.setState({yearsBeenPhotographer:this.props.signedData.photographer_experience['years_been_photographer']});
			this.setState({hasPayedWork:this.props.signedData.photographer_experience['has_payed_work']});
			this.setState({projectsPayedCount:this.props.signedData.photographer_experience['projects_payed_count']});
			this.setState({selfDescribe:this.props.signedData.photographer_experience['self_describe']});
			this.setState({bio:this.props.signedData.photographer_experience['bio']});
			this.setState({passion:this.props.signedData.photographer_experience['passion']});
			this.setState({loveJob:this.props.signedData.photographer_experience['love_job']});
			this.setState({favoriteShoots:this.props.signedData.photographer_experience['favorite_shoots']});
			this.setState({shoots:this.props.signedData.photographer_experience['shoots']});
			this.setState({cityShoots:this.props.signedData.photographer_experience['city_shoots']});
			this.setState({awards:this.props.signedData.photographer_experience['awards']});
			this.setState({funFact:this.props.signedData.photographer_experience['fun_fact']});
		}
		if(this.props.directToStep && prevProps.directToStep!==this.props.directToStep && this.props.directStep==3)
		{
        	$('html, body').animate({scrollTop:0}, 'slow');
        }
	}
	
	handlePayedWorkClick()
	{
		this.setState({hasPayedWork: true});
		$('#projects_payed_for').removeClass('hidden');
		$("#projects_payed_count").prop('required',true);
	}
	handleNotPayedWorkClick()
	{
		this.setState({hasPayedWork: false});
		this.setState({projectsPayedCount: null});
		$('#projects_payed_for').addClass('hidden');
		$("#projects_payed_count").prop('required',false);
	}
	handleYearsBeenPhotographerChange(event){
		if(event.target.value=='')
			this.setState({yearsBeenPhotographer: null});
		else
			this.setState({yearsBeenPhotographer: event.target.value});
	}
	handleProjectsPayedCountChange(event){
		if(event.target.value=='')
			this.setState({projectsPayedCount: null});
		else
			this.setState({projectsPayedCount: event.target.value});
	}
	handleSelfDescribeChange(event){
		
		this.inputChanged["self_describe"] =true;
		if(event.target.value=='')
			this.setState({selfDescribe: null});
		else
			this.setState({selfDescribe: event.target.value});
	}
	handleBioChange(event){
		this.inputChanged["bio"] =true;
		if(event.target.value=='')
			this.setState({bio: null});
		else
			this.setState({bio: event.target.value});
	}
	handlePassionChange(event){
		this.inputChanged["passion"] =true;
		if(event.target.value=='')
			this.setState({passion: null});
		else
			this.setState({passion: event.target.value});
	}
	handleLoveJobChange(event){
		this.inputChanged["love_job"] =true;
		if(event.target.value=='')
			this.setState({loveJob: null});
		else
			this.setState({loveJob: event.target.value});
	}
	handleFavoriteShootsChange(event){
		this.inputChanged["favorite_shoots"] =true;
		if(event.target.value=='')
			this.setState({favoriteShoots: null});
		else
			this.setState({favoriteShoots: event.target.value});
	}
	handleShootsChange(event){
		this.inputChanged["shoots"] =true;
		if(event.target.value=='')
			this.setState({shoots: null});
		else
			this.setState({shoots: event.target.value});
	}
	handleCityShootsChange(event){
		this.inputChanged["city_shoots"] =true;
		if(event.target.value=='')
			this.setState({cityShoots: null});
		else
			this.setState({cityShoots: event.target.value});
	}
	handleAwardsChange(event){
		this.inputChanged["awards"] =true;
		if(event.target.value=='')
			this.setState({awards: null});
		else
			this.setState({awards: event.target.value});
	}
	handleFunFactChange(event){
		this.inputChanged["fun_fact"] =true;
		if(event.target.value=='')
			this.setState({funFact: null});
		else
			this.setState({funFact: event.target.value});
	}
	onBlur(event){
		if(this.inputChanged[event.target.id])
		{
			this.callExperienceApi();
			this.inputChanged[event.target.id]=false;

		}
	}
	callExperienceApi(){
		let data={
			experience:{
				years_been_photographer:this.state.yearsBeenPhotographer,
				has_payed_work:this.state.hasPayedWork,
				projects_payed_count:this.state.projectsPayedCount,
				self_describe:this.state.selfDescribe,
				bio:this.state.bio,
				passion:this.state.passion,
				love_job:this.state.loveJob, 
				favorite_shoots:this.state.favoriteShoots,
				shoots:this.state.shoots,
				city_shoots:this.state.cityShoots,
				awards:this.state.awards,
				fun_fact:this.state.funFact,
				photographer_id:this.props.photographerId
			}
		};
		let body = JSON.stringify(data);
        let url=this.props.link+'/api/v1/experiences';
        //console.log(body);
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/json","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{
				//console.log(response);
				if (parseInt(response.status) !== 200) {

            		response.json().then((object) =>{
					});
            	}
                else{
					response.json().then((object) =>{
						//console.log(object);
					});
				}
     
            	
            	
            })
            .catch(function(e){console.log(e)});
	}
	handleInformationValidation(){
		
		let formIsValid = true;
        $('#years_been_photographer').parsley().validate();
		$('#projects_payed_count').parsley().validate();
		$('#self_describe').parsley().validate();
		$('#bio').parsley().validate();
        $('#passion').parsley().validate();
        $('#love_job').parsley().validate();
        $('#favorite_shoots').parsley().validate();
        $('#shoots').parsley().validate();
        $('#city_shoots').parsley().validate();
        $('#awards').parsley().validate();
        $('#fun_fact').parsley().validate();
        if(
        	!$('#years_been_photographer').parsley().isValid() ||
			!$('#projects_payed_count').parsley().isValid() || 
        	!$('#self_describe').parsley().isValid() || 
        	!$('#bio').parsley().isValid()|| 
        	!$('#passion').parsley().isValid()||
        	!$('#love_job').parsley().isValid()||
        	!$('#favorite_shoots').parsley().isValid() ||
        	!$('#shoots').parsley().isValid() ||
			!$('#city_shoots').parsley().isValid() || 
        	!$('#awards').parsley().isValid() || 
        	!$('#fun_fact').parsley().isValid()
        )
        {
            formIsValid = false;

        }
		
      	return formIsValid;
	}
	handleSubmitButton(){
		if(this.handleInformationValidation())
		{
			this.callExperienceApi();
			$('#submitExperienceError').css('display', 'none');
			window.location.replace(this.props.link+'/photographers/sign_in?notice=done_register')
			//this.props.nextStep();
		}
		else{
			$('#submitExperienceError').css('display', 'block');
			$('html, body').animate({scrollTop:0}, 'slow');
		}
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
									<span className="step-line step-line-details active" style={{width:'33.3333%',right: '66.6667%'}}></span>
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
								<div className="process-tab-button tracker-circle selected" style={{right: '100%'}}>
									<div className="tracker-text">
									تجربه کاری
									</div>
								</div>
							</div>
							<div className="wrapper">
								<div className="row" style={{marginBottom: '30px'}}>
									<div className="col-sm-12 text-right text-muted" style={{marginTop: '1%'}}>

										<span className="my-alert">توجه:</span> ورودی های <span className="my-alert">{' ستاره '}</span> دار الزامی می‌باشند.
									</div>
									<div className="col-sm-12">
										<p className="text-center">
										مشتریان کادرو به دنبال عکاسان حرفه ای هستند که
							              یک سابقه اثبات شده در
							              <br />
							              انجام و تحویل عکس های حرفه ای
							              دارند.
							              به ما اجازه دهید در مورد سابقه کاری شما  به عنوان
							              <br />
							              یک عکاس  بیشتر بدانیم.
										</p>
										<hr />
										<div className="alert alert-danger" id="submitExperienceError" style={{ display: "none"}}>
											<p id="errors">همه موارد باید به دقت پر شوند</p>
										</div>
									</div>
									<div className="col-sm-6">
										<div className="col-sm-12">
											<h5>
							                چند سال عکاس بوده اید؟
											</h5>
											<input className="form-control" type="number" id="years_been_photographer"
											value={this.state.yearsBeenPhotographer} onChange={this.handleYearsBeenPhotographerChange} />
											
							            </div>
							            <div id="projects_payed_for" className="col-sm-12 hidden">
											<h5 >
											به صورت حدودی چند پروژه با کسب درآمد انجام داده اید؟
											</h5>
											
											<input className="form-control " type="number" id="projects_payed_count" 
											value={this.state.projectsPayedCount} onChange={this.handleProjectsPayedCountChange} />
										</div>
									</div>
									<div className="col-sm-6">
										<h5>
										تا به حال از عکاسی کسب درآمد کرده اید؟
										</h5>
										<div className="radio-group">
											<input type="radio" id="payed_work_no" checked={!(this.state.hasPayedWork)} name="payed_work" value="no" />
											<label onClick={this.handleNotPayedWorkClick} htmlFor="payed_work_no">خیر</label>
											<input type="radio" name="payed_work" checked={this.state.hasPayedWork} value="yes" id="payed_work_yes" name="selector" />
											<label onClick={this.handlePayedWorkClick} htmlFor="payed_work_yes">بله</label>
										</div>
									</div>
									<div className="col-sm-12">
										<h5>
										<span style={{color:'red'}}>*</span> 
										 لطفا تجربه خود را به عنوان یک عکاس توصیف کنید.
										</h5>
										<textarea required className="form-control" id="self_describe" placeholder="یک چیزی اینجا بنویسید..." 
										value={this.state.selfDescribe} onChange={this.handleSelfDescribeChange} onBlur={this.onBlur} ></textarea>

										<h4 style={{fontSize: '0.9em', marginTop: '5px'}}>
										این پاسخ توسط تیم ما بررسی می شوند و روی صفحه شخصی شما نمایش داده نمی شوند.
										</h4>
										<br />
									</div>
									<h3 style={{marginBottom: '20px'}}>
									پاسخ به سوالات زیر روی صفحه شخصی شما نمایش داده خواهند شد:
									</h3>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 لطفا یک خلاصه کوتاه از تجربه ها، تمرین ها و علاقه تون برای عکاسی بنویسید.
										</h5>
									
										<textarea required className="form-control" id="bio" placeholder="امیررضا استواری یک عکاس حرفه ای است که برای شرکت ها و افراد مختلفی در تهران کار کرده است. اون مدرک لیسانس عکاسی از دانشکده هنر دارد و در عکاسی عروسی و عکاسی رویداد تخصص دارد و تا الان بیش از ۲۰۰ پروژه در تهران انجام داده است. او علاوه بر این تخصص قابل توجهی در عکاسی پرتره و محصول دارد، در شرکت دیجیکالا و بامیلو استخدام بوده و کارهای عکاسی آنها را انجام داده است."
										value={this.state.bio} onChange={this.handleBioChange}  onBlur={this.onBlur} 
										 ></textarea> 
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه سوم شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 چطوری عکاسی را آغاز کردید؟
										</h5>
										<textarea required className="form-control" id="passion" placeholder="من عکاسی را از زمانی شروع کردم که پدر بزرگم به من یک دوربین آنالوگ در تولد ۱۰ سالگی ام هدیه داد. از اینکه می تونستم از چیز های مختلف عکاسی کنم و لحظات رو ثبت کنم خیلی خوشحال بودم. در ۱۶ سالگی، پدرم برایم یک دوربین DSLR خرید و من رو در یک کلاس عکاسی ۲ ماهه ثبت نام کرد، از آنجا بود که وارد دنیای حرفه ای عکاسی شدم و تفریح عکاسی تبدیل به حرفه اصلی ام شد." 
										value={this.state.passion} onChange={this.handlePassionChange}  onBlur={this.onBlur} 
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 در عکاسی، چه چیزی شما را به وجد می آورد؟
										</h5>
										
										<textarea required className="form-control" id="love_job" placeholder="من عاشق قصه گویی هستم، به قول معروف، یک عکس هزار حرف دارد. عکاسی به من این فرصت را می دهد تا لحظات خاص در زندگی مردم را ثبت کنم و قصه آنها را صادقانه، منحصر بفرد و زیبا به اشتراک بگذارم. هیچ چیز لذت بخش تر از این نیست که لبخند رضایت روی چهره مشتری ام باشد زمانیکه برای اولین بار عکس هایش را می بیند. چشمهایشان چنان می درخشد انگار که در همان لحظه خاطره اش سیر می کند، یک عروسی، عقد، تولد و غیره. من دوست دارم آن کسی باشم که آن لحظه لذت بخش را می سازد." 
										value={this.state.loveJob} onChange={this.handleLoveJobChange} onBlur={this.onBlur} 
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 چه رشته هایی از عکاسی را بیشتر دوست دارید انجام دهید؟ و چرا؟
										</h5>
										
										<textarea required className="form-control" id="favorite_shoots" placeholder="من عاشق قصه گویی هستم، به قول معروف، یک عکس هزار حرف دارد. عکاسی به من این فرصت را می دهد تا لحظات خاص در زندگی مردم را ثبت کنم و قصه آنها را صادقانه، منحصر بفرد و زیبا به اشتراک بگذارم. هیچ چیز لذت بخش تر از این نیست که لبخند رضایت روی چهره مشتری ام باشد زمانیکه برای اولین بار عکس هایش را می بیند. چشمهایشان چنان می درخشد انگار که در همان لحظه خاطره اش سیر می کند، یک عروسی، عقد، تولد و غیره. من دوست دارم آن کسی باشم که آن لحظه لذت بخش را می سازد."
										value={this.state.favoriteShoots} onChange={this.handleFavoriteShootsChange} onBlur={this.onBlur}
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 چه رشته هایی از عکاسی را انجام داده اید و چطور سعی کردید آنها را ویژه کنید؟
										</h5>
										
										<textarea required className="form-control" id="shoots" placeholder="من در گذشته عکاسی پرتره خانوادگی بسیار انجام دادم. من تلاش می کنم کودکان را بخندانم چون در عالی شدن عکس ها خیلی تاثیر می گذارد و خانواده می تواند سال های آینده به آنها رجوع کنند و از دین آنها لذت ببرند. علاوه بر این من سعی می کنم شخصیت خانواده رو هم همانطور که هست ثبت کنم، برای مثال یک پدر و مادر جوان، من سعی می کنم یک ترکیب شاد و پر جنش و جوش را بسازم که نشان دهد چطور فرزندان می تونند کودک درون پدر و مادر را زنده کنند. من همچنین عکاسی های رویداد، از قبیل تولد ها و عقد و عروسی انجام داده ام که ..."
										value={this.state.shoots} onChange={this.handleShootsChange} onBlur={this.onBlur} 
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 چه مکان هایی در شهر را برای عکاسی دوست دارید ؟
										</h5>
										
										<textarea required className="form-control" id="city_shoots" placeholder="مکان مورد علاقه من برای عکاسی در تهران، باغ فردوس ولیعصر است، مخصوصا بعد از ظهر ها و قبل از غروب آفتاب. نور خورشید در آن ساعت با تابیدن بر ساختمان سفید رنگ باغ فردوس، نور بسیار خوبی برای عکاسی پرتره بوجود می آورد. من دوست دارم مشتری را با خودم به اطراف باغ ببرم و از موقعیت های مختلف با پس زمینه های متنوع عکاسی کنم."
										value={this.state.cityShoots} onChange={this.handleCityShootsChange} onBlur={this.onBlur} 
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 جوایز، افتخارات، مدارک و یا هر گونه تقدیرنامه که در عکاسی دریافت کرده اید را لیست کنید.
										</h5>
										
										<textarea required className="form-control" id="awards" placeholder="برنده مسابقه عکاسی تبلیغاتی در تهران، بهمن ۹۴، از طرف فصلنامه عکاسی"
										value={this.state.awards} onChange={this.handleAwardsChange} onBlur={this.onBlur}
										></textarea>
										
									</div>
									<div className="col-sm-12">
										<br />
										<h5>
										<span style={{color:'red'}}>*</span> 
										 یک نکته جالب در مورد خودتون به ما بگید.
										</h5>
										
										<textarea required className="form-control" id="fun_fact" placeholder="من نقاشی هم می کنم و حدود ۱۰ سال است که به اسکی روی آب می روم."
										value={this.state.funFact} onChange={this.handleFunFactChange} onBlur={this.onBlur}
										></textarea>
										<h4 style={{fontSize: '0.9em' , marginTop: '5px'}}>
										لطفا از دیدگاه اول شخص بنویسید.
										</h4>
									</div>
								</div>
							</div>{/*<!-- /.wrapper -->*/}
    					</div>{/*<!-- /.main -->*/}
					</div>{/*<!-- /.container -->*/}
				</section>{/*<!-- /.main -->*/}
				<footer id="footer">
				  <div className="container">
				    <div className="wrap">
				      <a className="btn btn-gray"  onClick={this.props.previousStep}> بازگشت </a>
				      <button type="submit" id ="submit_page_form" className="btn btn-blue" onClick={this.handleSubmitButton}  >ذخیره و ادامه
				      </button>
				    </div>
				  </div>
				</footer>
			</React.Fragment>
		);
	}
}