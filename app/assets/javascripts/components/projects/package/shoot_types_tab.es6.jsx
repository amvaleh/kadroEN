class ShootTypesTab extends React.Component{
    constructor(props) {
        super(props);
        this.state = {
            shoot_type_selected_id: '',
            mediumImageLink:'',
            more_clicked:false,
            service_packages:[],
            receiveType: '',
            privateGalleryOrderedPackages:[],
            memoryPlusOrderedPackages:[],
            galleryHours:[],
            memoryHours:[],
            galleryTicks:[],
            memoryTicks:[],
            wait:false,
            recommendationMemoryIndex:0,
            recommendationGalleryIndex:0,
            directInfoReceived:false,
        };

        this.findIndexOfHour=this.findIndexOfHour.bind(this);
        this.handleClickShootType=this.handleClickShootType.bind(this);
        this.handleClickMoreShootTypes=this.handleClickMoreShootTypes.bind(this);
        this.submitShootCallApi=this.submitShootCallApi.bind(this);
        this.checkHourPackagesHasOrder=this.checkHourPackagesHasOrder.bind(this);
        this.checkIndexAvailableInTickArray=this.checkIndexAvailableInTickArray.bind(this);
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
            this.setState({'receiveType':nextProps.receiveType});
        }
        else{

            this.setState({'receiveType':nextProps.receiveType});
        }
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
        }

    }

    handleClickShootType(event){

        this.setState({'receiveType':''});
        this.props.isServiceSelected_callBack2(false);
        let shootTypeSelectedId = event.currentTarget.getAttribute("data-id");
        this.props.shoot_type_selected_title_callBack(event.currentTarget.getAttribute("data-title"));
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
    checkIndexAvailableInTickArray(index,ticks){
        let founded=false;
        for (var i = ticks.length - 1; i >= 0; i--) {
            if(ticks[i]==index)
            {
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
        let privateGalleryOrderedPackages=[];
        let memoryPlusOrderedPackages=[];
        let galleryHours=[];
        let memoryHours=[];
        let memoryEnglishHours=[];
        let galleryEnglishHours=[];
        let galleryTicks=[];
        let memoryTicks=[];
        let hoursMemoryPackagesMap=[];
        let hoursGalleryPackagesMap=[];
        let thisHourGalleryPackages=[];
        let thisHourMemoryPackages=[];
        let shootTypeSelectedId = -1;
        if(this.props.direct)
        {
            shootTypeSelectedId=this.props.shoot_type_selected_id;
        }
        else{
            shootTypeSelectedId=id;
        }
        let body="shoot_type[id]="+shootTypeSelectedId+"&project_slug="+this.props.project_slug;

        let url=this.props.link+'/api/v1/submit_shoot_type';
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((r)=>r.json().then((r2) =>{
                let recommendationHour = r2['recommendation'];
                r2['packages'][0].sort((a, b) => a['order'] > b['order'] )
                    .map((item,i) =>{

                        if(item.is_full && this.checkHourPackagesHasOrder(item['order'],hoursMemoryPackagesMap)){
                            this.pushHourPackagesByOrder(item['order'],item,hoursMemoryPackagesMap);
                        }
                        else if(item.is_full && !this.checkHourPackagesHasOrder(item['order'],hoursMemoryPackagesMap))
                        {
                                let newMemoryPackages=[];
                                newMemoryPackages.push(item);
                                let packageMemoryMap={'order':item['order'],'packages':newMemoryPackages}
                                hoursMemoryPackagesMap.push(packageMemoryMap);

                        }
                        if(this.checkHourPackagesHasOrder(item['order'],hoursGalleryPackagesMap)){
                            this.pushHourPackagesByOrder(item['order'],item,hoursGalleryPackagesMap);
                        }
                        else if(!this.checkHourPackagesHasOrder(item['order'],hoursGalleryPackagesMap))
                        {
                            let newGalleryPackages=[];
                            newGalleryPackages.push(item);
                            let packageGalleryMap={'order':item['order'],'packages':newGalleryPackages}
                            hoursGalleryPackagesMap.push(packageGalleryMap);
                        }



                });
                hoursMemoryPackagesMap.sort(function(a, b) {
                    return a.order - b.order;
                });
                hoursGalleryPackagesMap.sort(function(a, b) {
                    return a.order - b.order;
                });
                for (let i = 0; i < hoursGalleryPackagesMap.length; i++) {
                    galleryEnglishHours.push(hoursGalleryPackagesMap[i].order);
                    galleryHours.push(this.hourMappingToPersian(hoursGalleryPackagesMap[i].order));
                    galleryTicks.push(i);

                    thisHourGalleryPackages=[];
                    for (let j = 0; j < hoursGalleryPackagesMap[i].packages.length; j++) {

                        if(hoursGalleryPackagesMap[i].packages[j].is_full)
                            hoursGalleryPackagesMap[i].packages[j]['description1']='دانلود همه عکس ها';

                        hoursGalleryPackagesMap[i].packages[j]['description']="دانلود "+
                            (toPersianNumber(hoursGalleryPackagesMap[i].packages[j]['digitals']))+" فایل از بین همه عکس ها (هر اضافی "+
                            (toPersianNumber(hoursGalleryPackagesMap[i].packages[j]['extra_price']))+
                            " تومان)";
                        thisHourGalleryPackages.push(hoursGalleryPackagesMap[i].packages[j]);
                    }
                    privateGalleryOrderedPackages.push(thisHourGalleryPackages);
                }
                for (let i = 0; i < hoursMemoryPackagesMap.length; i++) {
                    memoryEnglishHours.push(hoursMemoryPackagesMap[i].order);
                    memoryHours.push(this.hourMappingToPersian(hoursMemoryPackagesMap[i].order));
                    memoryTicks.push(i);

                    thisHourMemoryPackages=[];
                    for (let j = 0; j < hoursMemoryPackagesMap[i].packages.length; j++) {

                        hoursMemoryPackagesMap[i].packages[j]['description1']='دانلود همه عکس ها';
                        thisHourMemoryPackages.push(hoursMemoryPackagesMap[i].packages[j]);
                    }
                    memoryPlusOrderedPackages.push(thisHourMemoryPackages);
                }
                let recommendationGalleryIndex = this.findIndexOfHour(recommendationHour,galleryEnglishHours);
                let recommendationMemoryIndex = this.findIndexOfHour(recommendationHour,memoryEnglishHours);
                this.setState({shoot_type_selected_id: shootTypeSelectedId});
                this.props.shoot_type_selected_id_callBack1(shootTypeSelectedId);//be main
                this.props.shoot_type_selected_id_callBack2(shootTypeSelectedId);//be package
                this.setState({recommendationGalleryIndex: recommendationGalleryIndex});
                this.setState({recommendationMemoryIndex: recommendationMemoryIndex});
                this.setState({galleryHours: JSON.stringify(galleryHours)});
                this.setState({memoryHours: JSON.stringify(memoryHours)});
                this.setState({galleryTicks: JSON.stringify(galleryTicks)});
                this.setState({memoryTicks: JSON.stringify(memoryTicks)});
                this.setState({privateGalleryOrderedPackages: privateGalleryOrderedPackages});
                this.setState({memoryPlusOrderedPackages: memoryPlusOrderedPackages});
                this.setState({directInfoReceived: true});
                var target = $('#receive-type');
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
                    <ReceiveTypeTab
                    mediumImageLink={this.state.mediumImageLink}
                    shoot_type_selected_id={this.props.direct==false?this.state.shoot_type_selected_id:this.props.shoot_type_selected_id}
                    token={this.props.token}
                    project_slug={this.props.project_slug}
                    selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                    isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                    isServiceSelected_callBack3={this.props.isServiceSelected_callBack3}
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
                    shootTypeSelectedId={this.props.shootTypeSelectedId}
                    direct={this.props.direct}
                    directInfoReceived={this.state.directInfoReceived}
                    step={this.props.step}
                    />

                </div>
            </React.Fragment>
        );
    }
}
