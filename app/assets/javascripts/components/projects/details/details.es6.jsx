class Details extends React.Component {

	constructor(props) {
			super();
			this.state = {
	            fullName: props.fullName,
	            mobileNumber: props.mobileNumber,
				checkOneSelected:false,
				//checkTwoSelected:false,
				feedbackSelectedId: -1,
				styleDetails:'',
                wait:false,
                fullNameChanged:false,
                mobileNumberChanged:false,
                reservedCount:0,
			};
	        this.handleMobileNumberChange = this.handleMobileNumberChange.bind(this);
	        this.handleFullNameChange = this.handleFullNameChange.bind(this);
			this.handleSubmitButton=this.handleSubmitButton.bind(this);
			this.handleStyleDetailsChange=this.handleStyleDetailsChange.bind(this);
			this.handleSelectOptionsChange=this.handleSelectOptionsChange.bind(this);
			this.handleCheckOneSelectedChange=this.handleCheckOneSelectedChange.bind(this);
			//this.handleCheckTwoSelectedChange=this.handleCheckTwoSelectedChange.bind(this)
			this.handleValidation=this.handleValidation.bind(this);
			this.handleCallSubmitDetailApi=this.handleCallSubmitDetailApi.bind(this);
	}
	componentDidMount(){
		$("#feedback_channel").prepend("<option value='' selected='selected'>انتخاب کنید</option>");
	}
	componentDidUpdate(){
		if(!(this.props.fullName!='' && this.props.mobileNumber!='') )
    	{
			if(this.props.signed){
	            $('#mobile_number1').prop('readonly', true);
	        }
	    }
	}
	componentWillReceiveProps(nextProps){


		if(nextProps.fullName !== this.props.fullName)
		{
			this.setState({fullName:nextProps.fullName});
		}
		if (nextProps.mobileNumber !== this.props.mobileNumber)
		{
			this.setState({mobileNumber:nextProps.mobileNumber});
		}

		var timer= new timer_interface();

		if(nextProps.photographerSelectedId !== this.props.photographerSelectedId)
        {
        	timer.stop();
        	timer.start();
        }
        $('#submit_page_form').on('click', ()=> {
        	timer.stop();
		});

    }
    handleMobileNumberChange(event){
        let englishMobileNum=event.target.value.toEnglishDigits();
        this.setState({mobileNumber: englishMobileNum});
        if (!this.state.mobileNumberChanged)
        {
        	this.setState({mobileNumberChanged: true});
        }

    }
    handleFullNameChange(event){
        this.setState({fullName: event.target.value});
        if (!this.state.fullNameChanged)
        {
        	this.setState({fullNameChanged: true});
        }
    }
    handleValidation(){
		
    	//$('#mobile_number1').parsley().validate();
        $('#fullname1').parsley().validate();

        let formIsValid;
        if( !$('#fullname1').parsley().isValid())
        {
            formIsValid = false;
        }
        else{
           formIsValid = true;
        }

      	return formIsValid;
    }
    handleCallUpdateUserApi(){
        let body="user[full_name]="+this.state.fullName+"&user[mobile_number]="+this.state.mobileNumber+"&id="+this.props.project_slug;
        let url=this.props.link+'/api/v2/update_user';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.state.token }})
            .then(()=>{
            	this.setState({checkOneSelected:false});
				//this.setState({checkTwoSelected:false});

            	this.handleCallSubmitDetailApi();

			}).catch(function(e){console.log(e)});
    }
    handleCallSubmitDetailApi(){

		let url=this.props.link+"/api/v1/submit_detail";
		let body="detail[feedback_channel_id]="+this.state.feedbackSelectedId+"&detail[shoot_detail]="+this.state.styleDetails+"&project_slug="+this.props.project_slug;
    	return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{

            	if (parseInt(response.status) != 202) {
            		response.json().then((object) =>{

    				});

            	}
                else{


                	response.json().then((object) =>{
                		let data = {
                			fullName:this.state.fullName,
                			mobileNumber:this.state.mobileNumber,
                			transportationCost:object.transportation_cost,
                			subtotal:object.subtotal,
                			credit:object.credit,
                		}
                		this.props.mobileNumberCallBack(this.state.mobileNumber);
                		this.props.fullNameCallBack(this.state.fullName);
                		this.props.detailsFieldValues(data);
                		this.setState({wait:false});
                		this.setState({checkOneSelected:true});
						//this.setState({checkTwoSelected:true});
						this.props.nextStep();
            		});


    			}
		}).catch(function(e){console.log(e)});
    }

    handleSubmitButton(){
		
    	if(this.state.fullName==(null || '' ))
    	{
    		if(!this.handleValidation())
	    	{
	    		let target = $('#fullname1');
	            if( target.length ) {
		          	$('html, body').stop().animate({
		              scrollTop: target.offset().top
		          	}, 1000);
		        }
	    		return;
	    	}
		}
		else{
			if(!this.handleValidation())
	    	{
				let target = $('#fullname1');
	            if( target.length ) {
		          	$('html, body').stop().animate({
		              scrollTop: target.offset().top
		          	}, 1000);
		        }
	    		return;
			}
		}

    	if(this.state.fullNameChanged || this.state.mobileNumberChanged)
    	{
    		this.setState({wait:true});
			this.handleCallUpdateUserApi();
			this.setState({mobileNumberChanged: false});
			this.setState({fullNameChanged: false});
    	}
		else{
			this.setState({checkOneSelected:false});
			//this.setState({checkTwoSelected:false});
	    	this.setState({wait:true});
	    	this.handleCallSubmitDetailApi();
	    }



    }
	handleStyleDetailsChange(event){
        this.setState({styleDetails: event.target.value});
    }
    handleSelectOptionsChange(event){
        this.setState({feedbackSelectedId: event.target.value});
    }
    handleCheckOneSelectedChange(event){
    	this.setState({checkOneSelected: event.target.checked});
    }
    /*handleCheckTwoSelectedChange(event){
    	this.setState({checkTwoSelected: event.target.checked});
    }*/
	render () {
		let options=this.props.feedbacks
		.sort((a, b) => a['id'] > b['id'])
		.map((object,index) =>
		{
			return(
				<option value={object.id}>{object.title}</option>
			);
		});
	    return (
			<React.Fragment>
				<section id="main">
					<div className="container">
						<div className="main">
							<div className="wrapper" >
								<div className="time-remaining-title center" >
									<strong style={{color:"black"}} id="reservedCount">
									</strong>
									{' نفر در حال ثبت و سفارش با '}
									{(this.props.photographersFieldValues['firstName'])+" "+(this.props.photographersFieldValues['lastName'])}
									{' در روز مشابه هستند.'}
									<br />
									{'ما سفارش شما را تا '}
									<span id="timer" >
									</span>
									{' دقیقه دیگر نگه می داریم. '}
								</div>
								<label htmlFor="package_form" style={{marginTop: (mobileDisplay)?'6px':''}}>
									اطلاعات شما
								</label>
								<form noValidate="" className="form form-group" id="package_form" acceptCharset="UTF-8" method="post" style={{marginBottom: (mobileDisplay)?'10px':'0px'}}>

			                    	<div className="row" style={{marginTop: (mobileDisplay)?'-25px':'0px'}}>
			                            <div className="col-sm-6">
			                            	<label htmlFor="fullname"></label>
											<input 
											className="form-control" 
											name="fullname" 
											id="fullname1" 
											placeholder="نام و نام خانوادگی" 
											required 
											type="text" 
											value={this.state.fullName} 
											onChange={this.handleFullNameChange}
                                            
											/>

			                            </div>
			                            <div className="col-sm-6">
			                                <label htmlFor="mobile_number"></label>
			                                <input className="form-control" name="mobile_number" id="mobile_number1" placeholder="شماره موبایل" required type="tel"
	                                        data-parsley-pattern="^(\+98|0)?9\d{9}$" data-parsley-pattern-message="این مقدار باید شماره تلفن معتبر باشد"
	                                        value={this.state.mobileNumber} onChange={this.handleMobileNumberChange}
											style={{marginTop: (mobileDisplay)?'-18px':'0px'}}
											disabled={(this.props.mobileNumber==null||this.props.mobileNumber=="")?false:true}
	                                        />
			                            </div>

	                                    <div className="col-sm-6">
	                                        {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
	                                    </div>
			                        </div>

								</form>
								<div className="row" id="detail">
									<div className="col-sm-12 col-xs-12">
										<div className="form-group">
											<label htmlFor="photo-style">
											جزئیات عکاسی مورد نیاز شما:
											</label>
											<textarea
											name="shoot-style"
											rows="5"
											className="form-control style-textarea"
											id="photo-style"
											placeholder="هر آنچه که نیاز دارید را برای عکاس بنویسید. ژست خاص، تجهیزات نورپردازی، دکور یا  لینک به نمونه های مشابه را اینجا وارد کنید."
											value={this.state.styleDetails}
											onChange={this.handleStyleDetailsChange}
											>
											</textarea>
										</div>{/* /.form-group */}
									</div>{/* /.col sm 6 */}
								</div>{/* /.row */}
								<div className="row">
									<div className="col-sm-12">
										<div className="form-group" style={{marginTop: "30px"}}>
											<div className="checkbox-control">
												<input
												type="checkbox"
												id="check1"
												value="انتخاب توافق"
												required=""
												data-parsley-multiple="check1"
												checked={this.state.checkOneSelected}
            									onChange={this.handleCheckOneSelectedChange}
            									/>
												<label htmlFor="check1"> من <a href="https://kadro.co/terms/" target="_blank">"شرایط و مقررات"</a> کادرو را می پذیرم.</label>
											</div>
											{/*<div className="checkbox-control">
												<input
												type="checkbox"
												id="check2"
												value="قوانین"
												required=""
												data-parsley-multiple="check2"
												checked={this.state.checkTwoSelected}
            									onChange={this.handleCheckTwoSelectedChange}
												/>
												<label htmlFor="check2">
												  من با شرط لغو زیر موافق هستم:
												</label>
											</div>*/}
										</div>{/* /.form-group */}
										<p style={{color: "#b2bcc7", fontSize: "12px"}}>
											زمان و مکان پروژه تا ۲۴ ساعت مانده به رزرو شما
											قابل تغییر نیست.
											اولین تغییر زمان یا مکان بدون هزینه انجام می شود، تغییر های
											بعدی مستلزم پرداخت هزینه است.
											هیچ بازپرداخت مبلغی
											در صورت
											کنسلی یا عدم حضور شما در زمان پروژه وجود ندارد.
										</p>
									</div>{/* /.col sm 12 */}
								</div>{/* /.row */}
							</div>{/* /.wrapper */}
							<div className="row full-continue-btn">
								<div className="col-sm-4 col-sm-offset-4">
									<ContinueButton
									handleSubmitButton={this.handleSubmitButton}
									continueButtonDisabled={!(this.state.checkOneSelected)}
									wait={this.state.wait}
                                    payment={false}
									/>
								</div>
                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
								{/*<Tracker
			      					step={this.props.step}
			      				/>*/}

							</div>
							<br />
						</div>{/* /.main */}
					</div>{/* /.container -->*/}
					<BookFooter
						backButtonDisabled={false}
						previousStep={this.props.previousStep}
						handleSubmitButton={this.handleSubmitButton}
						continueButtonDisabled={!(this.state.checkOneSelected)}
						wait={this.state.wait}
						payment={false}
					/>
					<WaitingPopup wait={this.state.wait}/>
				</section>
			</React.Fragment>
	    );
  	}
}