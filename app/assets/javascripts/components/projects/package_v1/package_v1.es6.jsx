
class PackageV1 extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            fullName: props.fullName,
            mobileNumber: props.mobileNumber,
            selectedServicePackageId:-1,
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
            isMapShown:false,
            whereFieldValues:{},
            locationWasSelected:props.locationWasSelected,
            shootLocationTitle:'',
            photographerUid:-1,
            directShootTypeSelectedTitle:'',
            directShootTypeSelectedExtendedCost:'',
            mapIsSubmitted:false,
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
        this.resetLocation=this.resetLocation.bind(this);
        this.callDirectPhotographerMissedApi=this.callDirectPhotographerMissedApi.bind(this);
        this.handleChangeIsMapShown=this.handleChangeIsMapShown.bind(this);
        this.handleDirectSubmitButton=this.handleDirectSubmitButton.bind(this);
        this.allPersonalShootTypes=[];
        this.allBusinessShootTypes=[];
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
        if(nextProps.locationWasSelected!==this.props.locationWasSelected)
        {
            this.setState({locationWasSelected:nextProps.locationWasSelected});
        }
        if(nextProps.removeDirectPhotographer!==this.props.removeDirectPhotographer)
        {
            this.setState({removeDirectPhotographer:nextProps.removeDirectPhotographer});
            if(nextProps.removeDirectPhotographer && this.state.locationWasSelected)
            {
                this.setState({locationWasSelected:false});
            }
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
        /*
        if(!this.handleInformationValidation())
            return;
        */

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
        /*
        if(!this.handleInformationValidation())
            return;
        */
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
    resetLocation(){

        ///remove shoot location from url
        let url = window.location.href;

        let index=url.indexOf("shoot_location=");
        let newUrl="";

        if(index!=-1)
        {
            newUrl=url.substring(0, index-1);
        }
        
        window.history.pushState({path:newUrl},'',newUrl);

        ///if we already initialialized direct shoot types and stored all shoot types
        if(this.allBusinessShootTypes.length>0 || this.allPersonalShootTypes.length>0)
        {
            ///bring back all shootTypes and change shoot types states
            this.setState({business_shoot_types: this.allBusinessShootTypes});
            this.setState({personal_shoot_types: this.allPersonalShootTypes});
            if(this.allPersonalShootTypes.length==0)
            {
                this.setState({selectedType:'business'});
            }
            else if(this.allBusinessShootTypes.length==0)
            {
                this.setState({selectedType:'personal'});
            }
        }

        ///if we had photographerUid
        if(this.state.photographerUid!=-1)
        {
            
            this.callDirectPhotographerMissedApi();
            this.setState({photographerUid:-1});
            this.props.photographerUidCallBack2(-1);
        }
        ///
        this.setState({locationWasSelected:false});
        this.setState({removeDirectPhotographer:true});
    }
    callDirectPhotographerMissedApi(){
        let body="direct_photographer_missed="+this.state.photographerUid+"&project_slug="+this.state.project_slug;
        let url=this.props.link+'/api/v2/switched_direct_photographer';

        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.state.token }})
            .catch(function(e){console.log(e)});
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

        let linkUrl = window.location.href;
        let locationIndex=linkUrl.indexOf("shoot_location=");
        let locationHash='';
        if(locationIndex!=-1)
            locationHash=linkUrl.substring(locationIndex+15, linkUrl.length);
        let shootLocationParameter = (locationIndex!=-1)? '&shoot_location='+locationHash : "";
        let body="user[full_name]="+this.state.fullName+"&user[mobile_number]="+mobileNumber+shootLocationParameter;
        let url=this.props.link+'/api/v3/users/';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" }})
            .then((r)=>r.json().then((r2) =>{
                if(this.state.personal_shoot_types.length==0 || this.state.business_shoot_types.length==0)
                {
                    if(r2['direct_shoot_types'][0]==null ||  r2['direct_shoot_types'][0].length==0)
                    {
                        //setState all_shoot_types
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
                        if(personal_shoot_items.length==0)
                        {
                            this.setState({selectedType:'business'});
                        }
                        else if(business_shoot_items.length==0)
                        {
                            this.setState({selectedType:'personal'});
                        }
                        this.setState({business_shoot_types: business_shoot_items});
                        this.setState({personal_shoot_types: personal_shoot_items});
                    }
                    else{
                        r2['direct_shoot_types'][0]
                        .map((item) =>{

                            if(JSON.stringify(item['is_personal'])==='true'){
                                personal_shoot_items.push(item);
                            }
                            if(JSON.stringify(item['is_business'])==='true'){
                                business_shoot_items.push(item);
                            }

                        });
                        //setState direct_shoot_types
                        if(personal_shoot_items.length==0)
                        {
                            this.setState({selectedType:'business'});
                        }
                        else if(business_shoot_items.length==0)
                        {
                            this.setState({selectedType:'personal'});
                        }
                        this.setState({business_shoot_types: business_shoot_items});
                        this.setState({personal_shoot_types: personal_shoot_items});

                        //store all_shoot_types for future
                        r2['shoot_types'][0]
                        .map((item) =>{

                            if(JSON.stringify(item['is_personal'])==='true'){
                                this.allPersonalShootTypes.push(item);
                            }
                            if(JSON.stringify(item['is_business'])==='true'){
                                this.allBusinessShootTypes.push(item);
                            }

                        });
                        this.allPersonalShootTypes.sort(function(a, b) {
                            return a.order - b.order;
                        });
                        this.allBusinessShootTypes.sort(function(a, b) {
                            return a.order - b.order;
                        });
                    }
                    this.setState({token: r2['token']});
                    this.props.token(r2['token']);
                    this.setState({project_slug: r2['project_slug']});
                    this.props.project_slug(r2['project_slug']);
                    this.props.projectIdInitCallBack(r2['project_id']);
                    if(this.props.direct)
                    {
                        ///this code is just for times when we are in direct mode and we don't have any shoot type selecting process otherwise the extended cost is received from shoot type selection method
                        //so we have to search all shoot types and find the direct shoot type infos
                        r2['shoot_types'][0]
                        .map((item) =>{
                            if(item.id==this.props.shootTypeSelectedId){
                                this.setState({directShootTypeSelectedTitle:item.title});
                                this.setState({directShootTypeSelectedExtendedCost:item.half_hour_extend_cost});
                            }

                        });

                        this.setState({startDirect:true});
                    }
                    if(r2.shoot_location!=null)
                    {
                        this.setState({shootLocationTitle:r2.shoot_location.title});
                    }
                    else if(locationIndex!=-1){
                        this.setState({locationWasSelected:false});
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
        
        let directAndPhotographerSelected= (!this.state.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
        let photographerUid = (directAndPhotographerSelected) ? this.props.photographerUid : "" ;
        let error_messages = {};
        let body="reserve[package_id]="+this.state.selectedServicePackageId+"&photographer="+photographerUid+"&project_slug="+this.state.project_slug;

        let url=this.props.link+'/api/v3/submit_package';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.state.token }})
            .then((response)=>{
                this.setState({wait:false});
                this.setState({isServiceSelected:false});
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
                            avatarUrl: this.state.whereFieldValues.avatarUrl,
                            availableHours: this.state.whereFieldValues.availableHours,
                            photographerName: this.state.whereFieldValues.photographerName,
                            unAvailablePhotographerDays:this.state.whereFieldValues.unAvailablePhotographerDays,
                            addressLng: this.state.whereFieldValues.addressLng,
                            addressLat: this.state.whereFieldValues.addressLat,
                            studioSelected: this.state.whereFieldValues.studioSelected,
                            addressInput: this.state.whereFieldValues.addressInput,
                            addressDetail: this.state.whereFieldValues.addressDetail
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
        /*
        if(!this.props.direct &&!this.handleInformationValidation())
        {
            $("html, body").animate({ scrollTop: 0 }, "slow");

            return;
        }*/
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
        if(this.state.isMapShown)
        {
            this.setState({mapIsSubmitted:true});
        }
        else if(this.state.selectedServicePackageId==-1 && this.props.locationWasSelected)
        {
            var target= $('#receive-type');
            if( target.length ) {
              $('html, body').stop().animate({
                  scrollTop: target.offset().top
              }, 1000);
            }
        }
        else if(this.state.selectedServicePackageId!==-1 )
        {
            this.setState({wait:true});
            this.handleCallSubmitServicePackageApi();
        }
    }
    handleDirectSubmitButton(data){
        this.setState({selectedServicePackageId:data.id},()=>{
            
            this.setState({isServiceSelected:true},()=>{
                
                this.setState({servicePackageSelectedData:data},()=>{
                    
                    this.setState({wait:true});
                    this.handleCallSubmitServicePackageApi();
                });
            }); 
        });
            
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
    handleChangeIsMapShown(isChanged)
    {
        this.setState({isMapShown:isChanged});
        if(!isChanged)
        {
            this.setState({mapIsSubmitted:false}); 
        }
    }
    render() {
        return (
            <React.Fragment>
                <div className="container">
                    <div className="main" >
                        {this.props.direct==false?<React.Fragment>
                        {(this.state.locationWasSelected)? <div className="col-sm-12 alert alert-success">
                                <div className="col-sm-8 text-center date-header-text-info">
                                    {'شما در حال رزرو عکاس در مکان '+(this.state.shootLocationTitle)+' هستید.'}
                                    <br />
                                    {'برای حذف این مکان و انتخاب مکان دلخواه خود روی دکمه ی روبرو کلیک کنید'}
                                </div>
                                <div className="col-sm-2">
                                    <button className="btn btn-success remove_photographer_btn btn-block" onClick={this.resetLocation} >
                                    انتخاب مکان دلخواه
                                    </button>
                                </div>
                            </div>:<React.Fragment></React.Fragment>}
                            <div className="wrapper" id="ask" style={{margin: "4% 0 0% 0"}}>
                                <div className="package">
                                    <h3>
                                        ۱-
                                        چه نوع عکاسی می خواهید؟
                                        <small style={{fontSize: "9px"}}> (انتخاب کنید) </small>
                                    </h3>
                                </div>
                                    
                                {(this.state.business_shoot_types.length==0 || this.state.personal_shoot_types.length==0)?<React.Fragment></React.Fragment>:

                                    <div className="speciality-type">
                                        <div className={ 'type-box border ' +((this.state.selectedType==='business')? 'selected':'')} value="business" onClick={this.renderBusiness} > کسب و کار</div>
                                        <div className={ 'type-box '+((this.state.selectedType==='personal') ? 'selected': "") } value="personal" onClick={this.renderPersonal}>شخصی</div>
                                    </div>}
                            </div>
                        </React.Fragment>:<React.Fragment></React.Fragment>}
                        
                        <SelectFieldTypeTabV1
                        selectedType={this.state.selectedType}
                        token={this.state.token}
                        project_slug={this.state.project_slug}
                        business_shoot_types={this.state.business_shoot_types}
                        personal_shoot_types={this.state.personal_shoot_types}
                        selectedServicePackageIdCallBack={(id) => this.setState({selectedServicePackageId:id})}
                        isServiceSelected_callBack1={(id) => this.setState({isServiceSelected:id})} // 3 ja taghir midan dokmeye edame ro
                        isServiceSelected_callBack2={(id) => this.setState({isServiceSelected:id})}
                        isServiceSelected_callBack3={(id) => this.setState({isServiceSelected:id})}
                        isMapShownCallBack={(id) => this.handleChangeIsMapShown(id)}
                        mapIsSubmitted={this.state.mapIsSubmitted}
                        shoot_type_selected_title_callBack={this.props.shoot_type_selected_title_callBack}
                        shoot_type_selected_id_callBack1={this.props.shoot_type_selected_id_callBack1}
                        shoot_type_selected_id_callBack2={(id) => this.setState({shoot_type_selected_id:id})}//vase inke age taghir dad type ro baghiye taghir konan
                        shoot_type_selected_id={this.props.direct==false?this.state.shoot_type_selected_id:this.props.shootTypeSelectedId}
                        servicePackageSelectedData_callBack={(id) => this.setState({servicePackageSelectedData:id})}
                        link={this.props.link}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.handleSubmitButton}
                        handleDirectSubmitButtonCallBack={this.handleDirectSubmitButton}
                        direct={this.props.direct}
                        startDirect={this.state.startDirect}
                        step={this.props.step}
                        locationWasSelected={this.state.locationWasSelected}
                        studioLat={this.props.studioLat}
                        studioLng={this.props.studioLng}
                        hasStudio={this.props.hasStudio}
                        removeDirectPhotographer={this.state.removeDirectPhotographer}
                        whereFieldValuesCallBack={(id)=>this.setState({whereFieldValues:id})}
                        whereFieldValuesCallBack1={(id)=>this.setState({whereFieldValues:id})}
                        photographerUid={this.props.photographerUid}
                        isMapChangedCallBack={this.props.isMapChangedCallBack}
                        photographerUidCallBack={this.props.photographerUidCallBack}
                        photographerUidCallBack1={(id)=>this.setState({photographerUid:id})}
                        directShootTypeSelectedTitle={this.state.directShootTypeSelectedTitle}
                        directShootTypeSelectedExtendedCost={this.state.directShootTypeSelectedExtendedCost}
                        setShowStudiosCallBack={this.props.setShowStudiosCallBack}
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
