class ShootTypesTabV1 extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
            shoot_type_selected_id: '',
            mediumImageLink:'',
            more_clicked:false,
            service_packages:[],
            receiveType: 'online-gallery',
            privateGalleryOrderedPackages:[],
            memoryPlusOrderedPackages:[],
            galleryHours:[],
            memoryHours:[],
            galleryTicks:[],
            memoryTicks:[],
            wait:false,
            recommendationMemoryIndex:0,
            recommendationGalleryIndex:0,
            recommendationHour:0,
            directInfoReceived:false,
            photographerDirectCityName:'',
            photographerDirectName:'',
            isMapChanged:false,
            locationWasSelected:props.locationWasSelected,
            removeDirectPhotographer:false,
            shootTypeSelectedTitle:'',
            shootTypeSelectedExtendedHourCost:'70000',
        };

        this.findIndexOfHour=this.findIndexOfHour.bind(this);
        this.handleClickShootType=this.handleClickShootType.bind(this);
        this.handleClickMoreShootTypes=this.handleClickMoreShootTypes.bind(this);
        this.submitShootCallApi=this.submitShootCallApi.bind(this);
        this.checkHourPackagesHasOrder=this.checkHourPackagesHasOrder.bind(this);
        this.pushHourPackagesByOrder=this.pushHourPackagesByOrder.bind(this);
        this.hourMappingToPersian=this.hourMappingToPersian.bind(this);
    }
    componentDidMount(){
        if(this.props.direct)
        {
            this.submitShootCallApi();
        }
    }
    componentWillReceiveProps(nextProps){

        if(nextProps.shoot_type_selected_id!==this.props.shoot_type_selected_id)
        {
            this.setState({'shoot_type_selected_id':nextProps.shoot_type_selected_id});
        }
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
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
        this.setState({mapIsSubmitted:nextProps.mapIsSubmitted});
        this.setState({receiveType:nextProps.receiveType});
    }

    handleClickShootType(event){
        this.setState({'receiveType':'online-gallery'});
        this.props.isServiceSelected_callBack2(false);
        let shootTypeSelectedId = event.currentTarget.getAttribute("data-id");
        this.props.shoot_type_selected_title_callBack(event.currentTarget.getAttribute("data-title"));
        this.setState({shootTypeSelectedTitle:event.currentTarget.getAttribute("data-title")});
        this.setState({shootTypeSelectedExtendedHourCost:event.currentTarget.getAttribute("data-ext")});
        this.submitShootCallApi(shootTypeSelectedId);


    }
    handleClickMoreShootTypes(){
        this.setState({'more_clicked': true});
    }
    checkHourPackagesHasOrder(order,hoursPackagesMap){
        let founded=false;
        for (var i = hoursPackagesMap.length - 1; i >= 0; i--) {

            if(hoursPackagesMap[i].order==order){
                founded=true;
            }

        }
        return founded;
    }
    pushHourPackagesByOrder(order,thisPackage,hoursPackagesMap){
            for (var i =0 ; i < hoursPackagesMap.length; i++) {

                if(hoursPackagesMap[i].order==order){

                    let newPackages=[];
                    newPackages=hoursPackagesMap[i].packages;
                    newPackages.push(thisPackage);
                    newPackages.sort(function(a, b) {
                        if(b.is_full)
                            return 1;
                        else
                            return -1;
                    });
                    hoursPackagesMap[i].packages=newPackages;

                }

            }

    }
    hourMappingToPersian(order){

        //convert English Float Numbers to Persian Number Words
        let persianLetters = "صفر یک دو سه چهار پنج شش هفت هشت نه";
        let persianMap = persianLetters.split(" ");
        if(Number(order) === order && order % 1 === 0)
        {
            return(order.toString().replace(/\d/g, function (m) {
                                                return persianMap[parseInt(m)];
                                            })+" ساعت ");
        }
        else{
            if(order<1){
                return("نیم ساعت");
            }
            else{
                let newOrder=Math.floor(order);
                return(newOrder.toString().replace(/\d/g, function (m) {
                                                    return persianMap[parseInt(m)];
                                                })+" ساعت و نیم");
            }
        }
    }
    findIndexOfHour(recommendation,hours){
        for (var i = 0; i < hours.length; i++) {
          if(hours[i]==recommendation)
          {
            return i;
          }
        }
        return 0;
    }
    submitShootCallApi(id){
        let shootTypeSelectedId = -1;
        if(this.props.direct)
        {
            shootTypeSelectedId=this.props.shoot_type_selected_id;
        }
        else{
            shootTypeSelectedId=id;
        }
        let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
        let photographerUidParameter = (directAndPhotographerSelected) ? '&photographer='+this.props.photographerUid : "" ;
        //getting shoot_location from url
        let linkUrl = window.location.href;
        let shootLocationUrlIndex=linkUrl.indexOf("shoot_location=");
        let locationHash='';
        if(shootLocationUrlIndex!=-1)
            locationHash=linkUrl.substring(shootLocationUrlIndex+15, linkUrl.length);
        let shootLocationParameter = (shootLocationUrlIndex!=-1)? '&shoot_location='+locationHash : "";
        //
        let body="shoot_type[id]="+shootTypeSelectedId+"&project_slug="+this.props.project_slug+shootLocationParameter+photographerUidParameter;
        let url=this.props.link+'/api/v3/submit_shoot_type';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((r)=>r.json().then((r2) =>{
                let recommendationHour = r2['recommendation'];
                let recommendationGalleryIndex = -1;
                let recommendationMemoryIndex = -1;
                let packageInfos = {
                    galleryEnglishHours: [],
                    galleryHours : [],
                    galleryTicks:[],
                    memoryEnglishHours:[],
                    memoryHours:[],
                    memoryTicks:[],
                    privateGalleryOrderedPackages:[],
                    memoryPlusOrderedPackages:[]
                };
                if(shootLocationUrlIndex!=-1) 
                {
                    packageInfos = packageArrangement(r2['packages'][0]);
                    recommendationGalleryIndex = this.findIndexOfHour(recommendationHour,packageInfos.galleryEnglishHours);
                    recommendationMemoryIndex = this.findIndexOfHour(recommendationHour,packageInfos.memoryEnglishHours);
                }
                //////
                this.setState({shoot_type_selected_id: shootTypeSelectedId});
                this.props.shoot_type_selected_id_callBack1(shootTypeSelectedId);//be main
                this.props.shoot_type_selected_id_callBack2(shootTypeSelectedId);//be package
                this.setState({recommendationHour: recommendationHour});
                this.setState({recommendationGalleryIndex: recommendationGalleryIndex});
                this.setState({recommendationMemoryIndex: recommendationMemoryIndex});
                this.setState({galleryHours: JSON.stringify(packageInfos.galleryHours)});
                this.setState({memoryHours: JSON.stringify(packageInfos.memoryHours)});
                this.setState({galleryTicks: JSON.stringify(packageInfos.galleryTicks)});
                this.setState({memoryTicks: JSON.stringify(packageInfos.memoryTicks)});
                this.setState({privateGalleryOrderedPackages: packageInfos.privateGalleryOrderedPackages});
                this.setState({memoryPlusOrderedPackages: packageInfos.memoryPlusOrderedPackages});
                this.setState({directInfoReceived: true});
                //
                if(r2.direct_city_name)
                {
                    this.setState({photographerDirectCityName:r2.direct_city_name});
                    this.setState({photographerDirectName:r2.direct_photographer_name});
                }
                if(r2.shoot_location!=null)
                {
                    let photographerDirectFirstName ="";
                    let photographerDirectLastName="";
                    let photographerFullName = "";
                    let photographerAvatarUrl="";
                     ////////////////
                    let unAvailableDays = [];
                    let availableHours =0;
                    if (r2.photographer) {
                        this.props.photographerUidCallBack(r2.photographer.uid);
                        this.props.photographerUidCallBack1(r2.photographer.uid);
                        photographerDirectFirstName = r2.photographer.first_name.charAt(0);
                        photographerDirectLastName = r2.photographer.last_name;
                        photographerFullName = photographerDirectFirstName +". "+photographerDirectLastName;
                        photographerAvatarUrl= r2.photographer.avatar.url;

                        let totalDays=[1,2,3,4,5,6,7];
                        if(r2.days)
                        {
                            for (var i = 0; i < totalDays.length; i++) {
                                if(!r2.days[0].includes(totalDays[i]))
                                    unAvailableDays.push(totalDays[i]);
                            }
                        }  

                        if(r2.available_hours)
                        {
                            availableHours = r2.available_hours;
                        }
                    }
                    
                   
                    ////////////////////////
                    let data = {
                        avatarUrl: photographerAvatarUrl,
                        availableHours: availableHours,
                        photographerName: photographerFullName,
                        unAvailablePhotographerDays:unAvailableDays,
                        addressLng: r2.address_shoot_location.longtitude,
                        addressLat: r2.address_shoot_location.lattitude,
                        studioSelected: r2.shoot_location.is_studio,
                        addressInput: r2.address_shoot_location.input,
                        addressDetail: r2.address_shoot_location.detail
                    }
                    this.props.whereFieldValuesCallBack1(data);
                }
                //
                var target;
                if(this.state.locationWasSelected)
                    target = $('#receive-type');
                else
                    target = $('#location-pick');
                if( target.length ) {
                  $('html, body').stop().animate({
                      scrollTop: target.offset().top
                  }, 1000);
                }

            }))
            .catch(function(e){console.log(e)});

    }
    render() {
        let limit= (window.innerWidth<970) ? 6 : 4;
        let shootItems= (this.props.direct==false) ? this.props.shoot_types
            .map((item,i) =>
            {
                if(this.state.more_clicked === false && i<limit && mobileDisplay)
                {
                    return(

                        <li className="col-xs-4 col-sm-4 col-md-3" key={i}>
                            <a >
                                <div
                                className={"specialty "+((this.state.shoot_type_selected_id===JSON.stringify(item['id']))? 'selected':'')}
                                data-id={item['id']}
                                data-value={item['avatar']['medium']['url']}
                                data-title={item['title']}
                                data-ext={item['half_hour_extend_cost']}
                                onClick={this.handleClickShootType}
                                >
                                    <img src={(mobileDisplay)?this.props.link+item['avatar']['medium']['url']:this.props.link+item['avatar']['large']['url']}   alt=""/>
                                    <span className="center">
                                        {item['title']}
                                    </span>

                                </div>
                            </a>
                        </li>
                     );
                }
                else if(this.state.more_clicked === true || !mobileDisplay){
                    return(

                        <li className="col-xs-4 col-sm-4 col-md-3" key={i}>

                            <div
                            className={"specialty "+((this.state.shoot_type_selected_id===JSON.stringify(item['id']))? 'selected':'')}
                            data-id={item['id']}
                            data-value={item['avatar']['medium']['url']}
                            data-title={item['title']}
                            data-ext={item['half_hour_extend_cost']}
                            onClick={this.handleClickShootType}
                            >
                                <img src={(mobileDisplay)?this.props.link+item['avatar']['medium']['url']:this.props.link+item['avatar']['large']['url']} alt=""/>
                                <span className="center">
                                    {item['title']}
                                </span>

                            </div>
                        </li>
                     );
                }





            }
        ): <React.Fragment> </React.Fragment>;
        return (
            <React.Fragment>

                <div className="wrapper" id="detail" >
                    {this.props.direct==false?<div id="specialities" className="specialties">
                        <br />
                        <ul className="row row-m10">
                            {shootItems}
                        </ul>
                        {mobileDisplay? <div className="show-more" style={{display: ((this.state.more_clicked) ? 'none' : 'block')}} onClick={this.handleClickMoreShootTypes}>
                            <span> بیشتر </span>
                        </div> : <div></div>}
                    </div>:<React.Fragment></React.Fragment>}
                    {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                    {(this.state.locationWasSelected==false && this.state.shoot_type_selected_id!='')?<WhereV1
                        mediumImageLink={this.state.mediumImageLink}
                        shoot_type_selected_id={this.props.direct==false?this.state.shoot_type_selected_id:this.props.shoot_type_selected_id}
                        project_slug={this.props.project_slug}
                        token={this.props.token}
                        selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                        isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                        isServiceSelected_callBack3={this.props.isServiceSelected_callBack3}
                        isMapShownCallBack={this.props.isMapShownCallBack}
                        mapIsSubmitted={this.state.mapIsSubmitted}
                        memoryPlusOrderedPackages={this.state.memoryPlusOrderedPackages}
                        privateGalleryOrderedPackages={this.state.privateGalleryOrderedPackages}
                        memoryPlusOrderedPackagesLength={this.state.memoryPlusOrderedPackages.length}
                        privateGalleryOrderedPackagesLength={this.state.privateGalleryOrderedPackages.length}
                        galleryHours={this.state.galleryHours}
                        memoryHours={this.state.memoryHours}
                        galleryTicks={this.state.galleryTicks}
                        memoryTicks={this.state.memoryTicks}
                        receiveType={this.state.receiveType}
                        recommendationHour={this.state.recommendationHour}
                        recommendationGalleryIndex={this.state.recommendationGalleryIndex}
                        recommendationMemoryIndex={this.state.recommendationMemoryIndex}
                        servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                        isMapChangedCallBack={this.props.isMapChangedCallBack}
                        link={this.props.link}
                        step={this.props.step}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                        directInfoReceived={this.state.directInfoReceived}
                        photographerUid = {this.props.photographerUid}
                        whereFieldValuesCallBack={this.props.whereFieldValuesCallBack}
                        photographerDirectCityName={this.state.photographerDirectCityName}
                        photographerDirectName={this.state.photographerDirectName}
                        removeDirectPhotographer={this.state.removeDirectPhotographer}
                        direct={this.props.direct}
                        studioLat={this.props.studioLat}
                        studioLng={this.props.studioLng}
                        hasStudio={this.props.hasStudio}
                        setShowStudiosCallBack={this.props.setShowStudiosCallBack}
                        locationWasSelected={this.state.locationWasSelected}
                        shootTypeSelectedTitle={this.props.direct?this.props.directShootTypeSelectedTitle:this.state.shootTypeSelectedTitle}
                        shootTypeSelectedExtendedHourCost={this.props.direct?this.props.directShootTypeSelectedExtendedCost:this.state.shootTypeSelectedExtendedHourCost}
                        />:<React.Fragment></React.Fragment>}
                        {(this.state.locationWasSelected && this.state.shoot_type_selected_id!='')?
                        <ReceiveTypeTabV1
                        mediumImageLink={this.state.mediumImageLink}
                        shoot_type_selected_id={this.state.shoot_type_selected_id}
                        token={this.props.token}
                        project_slug={this.props.project_slug}
                        selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                        isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                        memoryPlusOrderedPackages={this.state.memoryPlusOrderedPackages}
                        privateGalleryOrderedPackages={this.state.privateGalleryOrderedPackages}
                        memoryPlusOrderedPackagesLength={this.state.memoryPlusOrderedPackages.length}
                        privateGalleryOrderedPackagesLength={this.state.privateGalleryOrderedPackages.length}
                        galleryHours={this.state.galleryHours}
                        memoryHours={this.state.memoryHours}
                        galleryTicks={this.state.galleryTicks}
                        memoryTicks={this.state.memoryTicks}
                        receiveType={this.state.receiveType}
                        servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                        link={this.props.link}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                        recommendationGalleryIndex={this.state.recommendationGalleryIndex}
                        recommendationMemoryIndex={this.state.recommendationMemoryIndex}
                        direct={this.props.direct}
                        directInfoReceived={this.state.directInfoReceived}
                        step={this.props.step}
                        locationWasSelected={this.state.locationWasSelected}
                        shootTypeSelectedTitle={this.state.shootTypeSelectedTitle}
                        shootTypeSelectedExtendedHourCost={this.state.shootTypeSelectedExtendedHourCost}
                       />:<React.Fragment></React.Fragment>}
                        
                        

                </div>
            </React.Fragment>
        );
    }
}
