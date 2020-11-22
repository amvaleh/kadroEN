class Receipt extends React.Component {
constructor(props) {
    super(props);
    this.state = {
    	couponInput:'',
		error_messages:{},
        success_messages:{},
        subtotalWithDiscount:"",
        subtotalWithoutDiscount:"",
        packagePrice:"",
        discountAmount:0,
        credit:-1,
        usedCredit:false,
        usedCreditAmount:0,
        usedDiscountCode:false,
        wait:false,
        free_credit:false,
        smsDelivered:false,
	};
    this.callPaymentApi=this.callPaymentApi.bind(this);
    this.handleClickCouponButton=this.handleClickCouponButton.bind(this);
	this.handleCouponInputChange=this.handleCouponInputChange.bind(this);
	this.decreaseFromCredit=this.decreaseFromCredit.bind(this);
	this.handleSubmitMessageButton=this.handleSubmitMessageButton.bind(this);
}
componentWillReceiveProps(nextProps){
	{/*if(this.props.receiptWhereFieldValues['addressLat'] !== nextProps.receiptWhereFieldValues['addressLat'])
	{

    	$('input#addressLat').val(nextProps.receiptWhereFieldValues['addressLat']);
		$('input#addressLng').val(nextProps.receiptWhereFieldValues['addressLng']);
	    finalMap();
	}*/}
	if(this.props.detailsFieldValues['subtotal'] !== nextProps.detailsFieldValues['subtotal'])
	{
		this.setState({subtotalWithoutDiscount:nextProps.detailsFieldValues['subtotal']});
		this.setState({subtotalWithDiscount:nextProps.detailsFieldValues['subtotal']});
		this.setState({packagePrice:nextProps.packageFieldValues['price']});

	}
	if(nextProps.signed)
	{
		this.setState({credit:nextProps.detailsFieldValues['credit']});
	}

}
handleSubmitMessageButton(){
	let url = this.props.link+"/projects/sms_link/"+this.props.projectId;
	this.setState({smsDelivered:true});
	return fetch(url, {method:'get'})
            .catch(function(e){console.log(e)});
}
callPaymentApi(){
	this.setState({wait:true});
	$("#receipt_form").submit();
	this.setState({wait:false});
}
handleCouponInputChange(event){
	let loweredCase = event.target.value.toLowerCase();
	this.setState({couponInput: loweredCase});
}
handleClickCouponButton(){
    	//add empty coupon input validation
    	let error_message = {};
    	let success_message = {};
    	error_message["coupon"]="";
    	success_message["coupon"]="";
    	this.setState({error_messages: error_message});
    	this.setState({success_messages: success_message});

    	let body="coupon[code]="+this.state.couponInput+"&project_slug="+this.props.project_slug;
        let url=this.props.link+'/api/v1/check_coupon';
        fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{
            	response.json().then((object) =>{
            		if (object.response === "error") {
                		error_message["coupon"] = object.message;
                		this.setState({error_messages: error_message});

            		}
	            	else if(object.response === "ok"){
	            		this.setState({discountAmount:this.state.subtotalWithoutDiscount-object.discounted_price});
                		success_message["coupon"] = object.message;
                		this.setState({success_messages: success_message});
                		if(this.state.usedCredit)
                		{
                    		this.setState({subtotalWithDiscount:object.discounted_price-this.state.credit});
                		}
                		else{
                			this.setState({subtotalWithDiscount:object.discounted_price});
                		}
                		this.setState({free_credit:object.free_credit});
                		this.setState({usedDiscountCode:true});
	            	}

				})

     //       	console.log("coupon errors:"+this.state.error_messages["coupon"]);
            })
            .catch(function(e){console.log(e)});

}
decreaseFromCredit(){
	if(this.state.credit>0)
	{
		if(!this.state.usedCredit)
		{
			if(this.state.credit>this.state.subtotalWithDiscount)
			{
				this.setState({subtotalWithDiscount:0});
				this.setState({usedCreditAmount:this.state.subtotalWithDiscount});
			}
			else{
				this.setState({subtotalWithDiscount:this.state.subtotalWithDiscount - this.state.credit});
				this.setState({usedCreditAmount:this.state.credit});
			}
			this.setState({usedCredit:true});
		}
	}
	else{
		let error_messages = {};
		error_messages["credit"] = "اعتبار کافی نیست";
		this.setState({error_messages:error_messages});
	}
}
render () {
	let addedToAfterwardLink = (this.state.usedCredit)?"credit=true&":"";
	addedToAfterwardLink += (this.state.free_credit)?"free_credit=true&":"";
	addedToAfterwardLink += (this.state.free_credit)?"key="+this.state.couponInput+"&":"";
	let credit = (this.props.detailsFieldValues['credit'])?this.props.detailsFieldValues['credit']:0;
    let isFull = this.props.packageFieldValues['is_full'];
    let packageDigitals=this.props.packageFieldValues['digitals'];
   	let transportationCost=0;
   	if(this.props.detailsFieldValues['transportationCost'])
   		transportationCost=this.props.detailsFieldValues['transportationCost'];
    return (
		<section id="main">
			<div className="container">
				<div className="main">
					<div className="wrapper">
						<div className="row">
							<div className="col-sm-6" id="final-details">
								<h3 style={{marginTop: "0px"}}>اطلاعات نهایی</h3>
								<div className="detail-row">
                					<span className="fa fa-user"></span>
									<p>
										{this.props.detailsFieldValues['fullName']}
									</p>
								</div>
								<div className="detail-row">
									<div className="col-xs-12" style={{paddingRight: "0px !important",display: "contents"}}>
										<span className="fa fa-mobile" style={{fontSize: "25px",marginRight: "3px"}}></span>
										<p style={{paddingTop: "1px"}}>
										{this.props.detailsFieldValues['mobileNumber']}
										</p>
									</div>
									<div className="col-xs-12" style={{paddingLeft: "0px !important",float: "left"}}>
										{(!this.state.smsDelivered)?<button type="submit" id="send_factor_with_sms" className="btn btn-sm btn-gray" style={{width: "70%",margin: "0px",padding: "5px",float: "left"}} onClick={this.handleSubmitMessageButton} >ارسال فاکتور با پیامک</button>:<React.Fragment></React.Fragment>}
									</div>
								</div>
								<div className="detail-row">
                					<span className="fa fa-map-pin"></span>
									<p>
										{this.props.whereFieldValues['addressDetail']}
									</p>
								</div>
								<div className="detail-row">
                					<span className="fa fa-calendar-times-o"></span>
									<p>
										{(this.props.whenFieldValues['dateSelected'])+  " ساعت " +(this.props.whenFieldValues['timeSelected'])}
									</p>
								</div>
								<div className="detail-row">
                					<span className="fa fa-camera-retro"></span>
									<p> {"پکیج: "+
										(this.props.packageFieldValues['title'])
										+" - "+
										(this.props.packageFieldValues['duration'])
										+" - "+
										((isFull==true)?'همه فریم ها':toPersianNumber(packageDigitals)+" فریم دانلود")}
									</p>
								</div>
				            	<div className="detail-row">
				                	<span className="fa fa-camera"></span>
				                	<p>
										{
										(this.props.photographersFieldValues['firstName'])
										+" "+
										(this.props.photographersFieldValues['lastName'])
										}
									</p>
				                </div>
							</div>
							<div className="col-sm-6" id="final-prices">
									<h3>اطلاعات پرداخت</h3>

									<div className="detail-row">
		                				<div className="col-xs-8">
		                					<p>
							                	هزینه پکیج عکاسی:
							                </p>
					                	</div>
					                	<div className="col-xs-4">
							                <p>
										    	{"  "+toPersianNumber(makeDottedNumber(this.state.packagePrice))+" تومان"}
										    </p>
										</div>
									</div>
					                <div className="detail-row">
										<div className="col-xs-8">
		                					<p>
							                	هزینه ایاب ذهاب تا محل عکاسی:
							                </p>
										</div>
										<div className="col-xs-4">
							                 <p>
										    	{"  "+toPersianNumber(makeDottedNumber(transportationCost))+" تومان"}
										    </p>
									    </div>
									</div>
									<div className="detail-row">
										<div className="col-xs-8">
		                					<p>
							                	مالیات بر ارزش افزوده:
							                </p>
										</div>
										<div className="col-xs-4">
						                 	<p>
										   		۰ تومان
										   	</p>
									   	</div>
									</div>
									<div className="detail-row">
										<div className="col-xs-8">
		                					<h4 className="final-price">
							                	جمع کل:
							                </h4>
										</div>
										<div className="col-xs-4">
						                 	<h4 className="final-price text-right">
												{"  "+toPersianNumber(makeDottedNumber(this.state.subtotalWithoutDiscount))+" تومان "}
											</h4>
										</div>
									</div>
									<figure id="coupon">
							            <div className="input-box">
							                <input id="coupon_input" name="coupon" type="text" placeholder="کوپن تخفیف" value={this.state.couponInput} onChange={this.handleCouponInputChange}/>
							                <button id="coupon_submit_button" className="btn-orange" onClick={this.handleClickCouponButton}>اعمال کد</button>
							            </div>
							            <div id="coupon-result">
											<h4 className="error-message" style={{color: 'red'}}>{this.state.error_messages["coupon"]}</h4>
							                <h4 className="error-message" style={{color: 'green'}}>{this.state.success_messages["coupon"]}</h4>
							            </div>

									</figure>

									{(this.props.signed)?
											<React.Fragment>
												<hr />
												<div className="detail-row credit-row">

													<div className="col-sm-4 col-xs-6">
					                					<p>
										                	{"اعتبار کنونی:   "+toPersianNumber(makeDottedNumber(credit))+" تومان"}
										                </p>
													</div>

												   	<div className="col-sm-4  col-sm-offset-4 col-xs-6">
									                 	<button className="btn btn-default" onClick={this.decreaseFromCredit}>
									                 		{" استفاده از اعتبار "}
									                 		<i className="fa fa-credit-card"></i>
									                 	</button>
									                 	<h4 className="error-message" style={{color: 'red'}}>{this.state.error_messages["credit"]}</h4>
									                 	<h4 className="error-message" style={{color: 'green'}}>{this.state.success_messages["credit"]}</h4>
												   	</div>

												</div>
												<hr />
											</React.Fragment>:
											<React.Fragment></React.Fragment>
										}

								</div>
							{/*<div className="col-sm-6 hidden-xs" >
								<input type="hidden" id="addressLat" value={this.props.receiptWhereFieldValues['addressLat']}/>
								<input type="hidden" id="addressLng" value={this.props.receiptWhereFieldValues['addressLng']}/>
								<div id="finalMap" style={{width: '100%', height: '500px'}}></div>

							</div>*/}


						</div>{/*<!-- /.row -->*/}

						{(this.state.usedDiscountCode)?
						<div className="row">
							<div className="col-sm-4 col-sm-offset-4">
								<div className="col-xs-6">
									<p>
					                	مقدار تخفیف اعمال شده:
					                </p>

								</div>
								<div className="col-xs-6">
									<p>
								   		{"  "+toPersianNumber(makeDottedNumber(this.state.discountAmount))+" تومان"}
								   	</p>
								</div>
							</div>
						</div>

						:<div></div>}
						{(this.state.usedCredit)?
							<div className="row">
							<div className="col-sm-4 col-sm-offset-4">
								<div className="col-xs-6">
									<p>
					                	اعتبار:
					                </p>
								</div>
								<div className="col-xs-6">
									<p>
					                	{"  "+toPersianNumber(makeDottedNumber(this.state.usedCreditAmount))+" تومان"}
					                </p>
								</div>
							</div>

						</div>:<div></div>}

            <div className="row">
                <div className="col-xs-12 col-md-8 col-md-offset-2 col-lg-6 col-lg-offset-3">
                    <div className="col-xs-6">
                        <h3 className="payment-price text-right">
                            قابل پرداخت:
                        </h3>
                    </div>
                    <div className="col-xs-6">
                        <h3 className="payment-price text-left">
                            {"  "+toPersianNumber(makeDottedNumber(this.state.subtotalWithDiscount))+" تومان "}
                        </h3>
                    </div>
                </div>
            </div>
            <div className="row full-continue-btn">
                <div className="col-sm-4 payment-butaddedToAfterwardLinkton col-sm-offset-4">
                    <ContinueButton
                    handleSubmitButton={this.callPaymentApi}
                    continueButtonDisabled={false}
                    wait={this.state.wait}
                    payment={true}
                    />
                </div>
            </div>
            <div className="row" style={{padding: "1em 1em"}}>
                <div className="col-xs-12 col-md-8 col-md-offset-2 col-lg-10 col-lg-offset-2">
                    <div className=" col-xs-12 col-sm-8 col-md-10" style={{borderTop: '0.1em solid #dedede',borderBottom: '0.1em solid #dedede' }}>
                        <h6 className="text-center"><strong>
                            می دونستی
                            ۷ روز ضمانت
                            بازگشت مبلغ داری؟
                        </strong></h6>
                        <p className="text-center" style={{fontSize: "11px"}}>
                            مبلغ پرداختی شما تا
                            <strong> ۷ روز </strong>
                            به عکاس پرداخت نمی شود تا شما  عکسها را ببینید، اعلام رضایت کنید و مبلغ را برای عکاس
                            آزاد کنید.
                        </p>
                    </div>
                </div>
            </div>

            {/* <div className="row" style={{padding: "1em 0em"}}>
                <div className="col-xs-12 col-md-8 col-md-offset-2 col-lg-10 col-lg-offset-2">
                    <div className="well col-xs-12 col-sm-8 col-md-10" style={{borderTop: '0.1em solid #dedede',borderBottom: '0.1em solid #dedede' }}>
                        <h3 className="text-center text-primary" >
                            <strong>
                                رمز دوم پویا نداری؟
                            </strong>
                        </h3>
                        <p className="text-center" style={{fontSize: "11px"}}>
                            میتونی مبلغ
                            <strong>{"  "+toPersianNumber(makeDottedNumber(this.state.subtotalWithDiscount))+" تومان "}</strong>
                            را به شماره کارت کادرو واریز کنی تا پروژه عکاسی ات سریع ثبت نهایی شود.
                        </p>
                        <h4 className="text-center text-primary" >
                            <strong> 6219-8610-3871-8960  </strong>
                        </h4>
                        <h4 className="text-center">
                            <span className="text-muted"> بانک سامان - امیرمهدی واله</span>
                        </h4>
                        <p className="text-center text-primary" style={{fontSize: "11px"}}>
                            سپس اسکرین شات پرداخت تان را در چت آنلاین کادرو ارسال نمایید.
                        </p>
                    </div>
                </div>
            </div> */}
					</div>{/*<!-- /.wrapper -->*/}
				</div>{/*<!-- /.main -->*/}
			</div>{/* /.container -->*/}
			<form noValidate="" className="form form-group" id="receipt_form" action="/transactions/initial_send" acceptCharset="UTF-8" method="post" >
				<input type="hidden" name="transaction[amount]" value={this.state.subtotalWithDiscount} />
				<input type="hidden" name="transaction[afterwards_url]" value={"/projects/"+(this.props.project_slug)+"/success_payment_notification?"+addedToAfterwardLink}/>
				<input type="hidden" name="transaction[type]" value={"reserve-payment"}/>
				<input type="hidden" name="transaction[credit_usage]" value={this.state.usedCreditAmount}/>
				<input type="hidden" name="transaction[model_id]" value={this.props.project_slug}/>
				<input type="hidden" name="transaction[mobile_number]" value={this.props.detailsFieldValues['mobileNumber']}/>
				<input type="hidden" name="transaction[description]" value={" #"+(this.props.detailsFieldValues['mobileNumber'])+"  | #"+(this.props.packageFieldValues.title)+" - #"+(this.props.packageFieldValues.digitals)+" - #"+(this.props.whenFieldValues.dateSelected)+" ساعت " +(this.props.whenFieldValues.timeSelected)+" - #"+(this.props.photographersFieldValues.completeFirstName)+" #"+(this.props.photographersFieldValues.lastName)}/>
			</form>
			<BookFooter
				backButtonDisabled={false}
				previousStep={this.props.previousStep}
				handleSubmitButton={this.callPaymentApi}
				continueButtonDisabled={false}
				wait={this.state.wait}
				payment={true}
			/>
			<WaitingPopup wait={this.state.wait}/>
		</section>
    );
  }
}
