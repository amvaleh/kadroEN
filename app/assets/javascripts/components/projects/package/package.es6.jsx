
class Package extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            fullName: props.fullName,
            mobileNumber: props.mobileNumber,
            selectedType:"personal",
            token:"",
            project_slug:"",
            personal_shoot_types:[],
            business_shoot_types:[],
            isServiceSelected:false,
            error_messages: {},
            shoot_type_selected_id: '',
            price_type: '',
            servicePackageSelectedData:{},
            wait:false,
            fullNameChanged:false,
            mobileNumberChanged:false,
            startDirect:false,
        };
        this.handleMobileNumberChange = this.handleMobileNumberChange.bind(this);
        this.handleFullNameChange = this.handleFullNameChange.bind(this);
        this.renderPersonal = this.renderPersonal.bind(this);
        this.renderBusiness = this.renderBusiness.bind(this);
        this.handleCallShootTypesApi = this.handleCallShootTypesApi.bind(this);
        this.handleSubmitButton = this.handleSubmitButton.bind(this);
        this.handleCallUpdateUserApi=this.handleCallUpdateUserApi.bind(this);
        this.handleCallSubmitServicePackageApi=this.handleCallSubmitServicePackageApi.bind(this);
        this.handleInformationValidation = this.handleInformationValidation.bind(this);
    }
    componentDidMount(){
        if(this.props.signed){
            $('#mobile_number').prop('readonly', true);
        }
        if(this.props.direct){
            this.handleCallShootTypesApi();
        }
        else{
            this.handleCallShootTypesApi();

            //for setting the padding bottom to 390px
            this.props.businessOrPersonalSelectedCallBack(true);
            var target = $('#ask');
            if( target.length ) {
              $('html, body').stop().animate({
                  scrollTop: target.offset().top
              }, 1000);
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
    }
    handleMobileNumberChange(event){
        let englishMobileNum=event.target.value.toEnglishDigits();
        this.setState({mobileNumber: englishMobileNum});
        this.setState({'shoot_type_selected_id':''});
        this.setState({'isServiceSelected':false});
        this.setState({'selectedType':'hidden'});
        this.props.businessOrPersonalSelectedCallBack(false);
        if (!this.state.mobileNumberChanged)
        {
            this.setState({'mobileNumberChanged':true});
        }
    }
    handleFullNameChange(event){
        this.setState({fullName: event.target.value});
        this.setState({'shoot_type_selected_id':''});
        this.setState({'isServiceSelected':false});
        this.setState({'selectedType':'hidden'});
        this.props.businessOrPersonalSelectedCallBack(false);
        if (!this.state.fullNameChanged)
        {
            this.setState({fullNameChanged: true});
        }
    }
    handleInformationValidation(){

        ///mobile number pattern validation

        $('#mobile_number').parsley().validate();
        $('#fullname').parsley().validate();

        let formIsValid;
        if(!$('#mobile_number').parsley().isValid() || !$('#fullname').parsley().isValid())
        {
            formIsValid = false;
        }
        else{
           formIsValid = true;
        }

        return formIsValid;
    }
    renderBusiness(){
        if(!this.handleInformationValidation())
            return;

        if(this.state.mobileNumberChanged || this.state.fullNameChanged )
        {
            this.setState({'mobileNumberChanged':false});
            this.setState({'fullNameChanged':false});
            this.handleCallUpdateUserApi();
        }

        //for setting the padding bottom to 390px
        this.props.businessOrPersonalSelectedCallBack(true);
        //

        if(this.state.selectedType=='personal')
        {
            //reset
            this.setState({'shoot_type_selected_id':''});
            this.setState({'isServiceSelected':false});

        }
        this.setState({selectedType:"business"});
        var target = $('#detail');
        if( target.length ) {
          $('html, body').stop().animate({
              scrollTop: target.offset().top
          }, 1000);
        }

    }
    renderPersonal(){
        if(!this.handleInformationValidation())
            return;

        if(this.state.mobileNumberChanged || this.state.fullNameChanged )
        {
            this.setState({'mobileNumberChanged':false});
            this.setState({'fullNameChanged':false});
            this.handleCallUpdateUserApi();
        }

        //for setting the padding bottom to 390px
        this.props.businessOrPersonalSelectedCallBack(true);
        //

        if(this.state.selectedType=='business')
        {
            //reset
            this.setState({'shoot_type_selected_id':''});
            this.setState({'isServiceSelected':false});

        }
        this.setState({selectedType:"personal"});
        var target = $('#detail');
        if( target.length ) {
          $('html, body').stop().animate({
              scrollTop: target.offset().top
          }, 1000);
        }

    }
    handleCallShootTypesApi(){
        // Github fetch library : https://github.com/github/fetch
        // Call the API page
        let personal_shoot_items=[];
        let business_shoot_items=[];
        let mobileNumber='';
        if(this.state.mobileNumber=='')
            mobileNumber='09027993049';
        else
            mobileNumber=this.state.mobileNumber;

        let body="user[full_name]="+this.state.fullName+"&user[mobile_number]="+mobileNumber;
        let url=this.props.link+'/api/v2/users/';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" }})
            .then((r)=>r.json().then((r2) =>{
                if(this.state.personal_shoot_types.length==0 || this.state.business_shoot_types.length==0)
                {
                    r2['shoot_types'][0]
                    .map((item) =>{

                        if(JSON.stringify(item['is_personal'])==='true'){
                            personal_shoot_items.push(item);
                        }
                        if(JSON.stringify(item['is_business'])==='true'){
                            business_shoot_items.push(item);
                        }

                    });
                    personal_shoot_items.sort(function(a, b) {
                        return a.order - b.order;
                    });
                    business_shoot_items.sort(function(a, b) {
                        return a.order - b.order;
                    });
                    this.setState({token: r2['token']});
                    this.props.token(r2['token']);
                    this.setState({project_slug: r2['project_slug']});
                    this.props.project_slug(r2['project_slug']);
                    this.setState({business_shoot_types: business_shoot_items});
                    this.setState({personal_shoot_types: personal_shoot_items});
                    if(this.props.direct)
                    {
                        this.setState({startDirect:true});
                    }
                }

            }))
            .catch(function(e){console.log(e)});

// Now use it!
    }
    handleCallUpdateUserApi(){

        let fullName,mobileNumber;

        if(this.state.fullName=='')
            fullName='کادرو';
        else
            fullName=this.state.fullName;

        if(this.state.mobileNumber=='')
            mobileNumber='09027993049';
        else
            mobileNumber=this.state.mobileNumber;

        let body="user[full_name]="+fullName+"&user[mobile_number]="+mobileNumber+"&id="+this.state.project_slug;
        let url=this.props.link+'/api/v2/update_user';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.state.token }})
            .catch(function(e){console.log(e)});
    }
    handleCallSubmitServicePackageApi()
    {
        let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
        let photographerUid = (directAndPhotographerSelected) ? this.props.photographerUid : "" ;
        let error_messages = {};
        let body="reserve[package_id]="+this.state.selectedServicePackageId+"&photographer="+photographerUid+"&project_slug="+this.state.project_slug;

        let url=this.props.link+'/api/v1/submit_package';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.state.token }})
            .then((response)=>{
                this.setState({wait:false});
                if (parseInt(response.status) !== 202) {
                    response.json().then((object) =>{

                        error_messages["submit_package"] = object.messages;
                        this.setState({error_messages: error_messages});
                    })
                }
                else{
                    response.json().then((object) =>{
                        var data = {
                            fullName:this.state.fullName,
                            mobileNumber:this.state.mobileNumber,
                            title:this.state.servicePackageSelectedData.title,
                            duration:this.state.servicePackageSelectedData.duration,
                            is_full:this.state.servicePackageSelectedData.is_full,
                            digitals:this.state.servicePackageSelectedData.digitals,
                            price:this.state.servicePackageSelectedData.price,
                            photographerDirectCityName:object.direct_city_name,
                            photographerDirectName:object.direct_photographer_name,

                        }
                        this.props.packageFieldValuesCallBack(data);
                        this.props.selectedServicePackageIdCallBack(this.state.selectedServicePackageId);
                        this.props.nextStep();
                    })
                     
                }



            })
            .catch(function(e){console.log(e)});
    }
    handleSubmitButton(){
        if(!this.props.direct &&!this.handleInformationValidation())
        {
            $("html, body").animate({ scrollTop: 0 }, "slow");

            return;
        }
        if(this.state.mobileNumberChanged || this.state.fullNameChanged )
        {
            this.setState({'mobileNumberChanged':false});
            this.setState({'fullNameChanged':false});
            this.handleCallUpdateUserApi();
        }
        /*if(!this.state.submitButtonClickedFirstTime)
        {
            this.setState({submitButtonClickedFirstTime:true});
            var target = $('#more-notes');
            if( target.length ) {
          $('html, body').stop().animate({
              scrollTop: target.offset().top
          }, 1000);
        }
            return;
        }*/
        this.setState({wait:true});
        this.handleCallSubmitServicePackageApi();
    }
    componentDidUpdate(){
        $('a[href^="#"]').on('click', function(event) {
            var target = $(this.getAttribute('href'));
            if( target.length ) {
                  $('html, body').stop().animate({
                      scrollTop: target.offset().top
                  }, 1000);
            }
        });
    }
    render() {
        return (
            <React.Fragment>
                <div className="container">
                    <div className="main">

                        {this.props.direct==false?<React.Fragment><div className="wrapper">
                        <p className="text-center" style={{marginBottom: "40px",fontSize:"13px",color:"#0b72cc",paddingTop: "2em"}} >
                        <span className="fa fa-hand-o-down " > </span>
                          برای دیدن قیمت ها بروید پایین
                         <span className="fa fa-hand-o-down " > </span>
                        </p>
                            <h3 className="hidden" >اطلاعات شما <small> (اختیاری) </small></h3>
                            <form noValidate="" className="form form-group hidden" id="package_form">
                                <div className="row" >
                                    <div className="col-sm-6">
                                        <label htmlFor="fullname"></label>
                                        <input className="form-control" name="fullname" id="fullname" placeholder="نام و نام خانوادگی" type="text" value={this.state.fullName} onChange={this.handleFullNameChange}/>

                                    </div>
                                    <div className="col-sm-6">
                                        <label htmlFor="mobile_number"></label>
                                        <input className="form-control" name="mobile_number" id="mobile_number" placeholder="شماره موبایل" type="tel"
                                        data-parsley-pattern="^(\+98|0)?9\d{9}$" data-parsley-pattern-message="این مقدار باید شماره تلفن معتبر باشد"
                                        value={this.state.mobileNumber} onChange={this.handleMobileNumberChange}/>
                                    </div>

                                    <div className="col-sm-6">
                                        <br />
                                    </div>
                                </div>

                            </form>
                        </div>
                        <div className="wrapper" id="ask" style={{margin: "4% 0 0% 0"}}>
                            <div className="package">
                                <h3>
                                    ۱-
                                    چه نوع عکاسی می خواهید؟
                                    <small style={{fontSize: "9px"}}> (انتخاب کنید) </small>
                                </h3>
                            </div>

                            <div className="speciality-type">
                                <div className={ 'type-box border ' +((this.state.selectedType==='business')? 'selected':'')} value="business" onClick={this.renderBusiness} > کسب و کار</div>
                                <div className={ 'type-box '+((this.state.selectedType==='personal') ? 'selected': "") } value="personal" onClick={this.renderPersonal}>شخصی</div>
                            </div>
                        </div></React.Fragment>:<React.Fragment></React.Fragment>

                        }

                        <SelectFieldTypeTab
                        selectedType={this.state.selectedType}
                        token={this.state.token}
                        project_slug={this.state.project_slug}
                        business_shoot_types={this.state.business_shoot_types}
                        personal_shoot_types={this.state.personal_shoot_types}
                        selectedServicePackageIdCallBack={(id) => this.setState({selectedServicePackageId:id})}
                        isServiceSelected_callBack1={(id) => this.setState({isServiceSelected:id})} // 3 ja taghir midan dokmeye edame ro
                        isServiceSelected_callBack2={(id) => this.setState({isServiceSelected:id})}
                        isServiceSelected_callBack3={(id) => this.setState({isServiceSelected:id})}
                        shoot_type_selected_title_callBack={this.props.shoot_type_selected_title_callBack}
                        shoot_type_selected_id_callBack1={this.props.shoot_type_selected_id_callBack1}
                        shoot_type_selected_id_callBack2={(id) => this.setState({shoot_type_selected_id:id})}//vase inke age taghir dad type ro baghiye taghir konan
                        shoot_type_selected_id={this.props.direct==false?this.state.shoot_type_selected_id:this.props.shootTypeSelectedId}
                        servicePackageSelectedData_callBack={(id) => this.setState({servicePackageSelectedData:id})}
                        link={this.props.link}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.handleSubmitButton}
                        direct={this.props.direct}
                        startDirect={this.state.startDirect}
                        step={this.props.step}
                        />
                        <span style={{color: 'red'}}>{this.state.error_messages["submit_package"]}</span>
                    </div>


                </div>

                <BookFooter
                    backButtonDisabled={true}
                    previousStep={this.props.previousStep}
                    handleSubmitButton={this.handleSubmitButton}
                    continueButtonDisabled={!this.state.isServiceSelected}
                    wait={this.state.wait}
                    payment={false}
                />
            </React.Fragment>
        );
    }
}
