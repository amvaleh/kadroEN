class When extends React.Component {
    constructor() {
            super();
            this.state = {
                dateSelected:'',
                error_messages:{},
                availableHours:[],
                unAvailablePhotographerDays:[],
                wait:false,
                directPhotographerDeleted:false,
                whenWhereFieldValues:{},
                disabledDayLocations:[],
                photographerUid:'',
            };
            this.updateDisableDays=this.updateDisableDays.bind(this);
            this.callAvailableHoursApi=this.callAvailableHoursApi.bind(this);
            this.handleSubmitButton=this.handleSubmitButton.bind(this);
            this.callAvailablePhotographerApi=this.callAvailablePhotographerApi.bind(this);
            this.getListOfUnAvailableHours=this.getListOfUnAvailableHours.bind(this);
            this.getListOfNextUnAvailableHours=this.getListOfNextUnAvailableHours.bind(this);
            this.callDirectPhotographerMissedApi=this.callDirectPhotographerMissedApi.bind(this);
            this.removeDirectPhotographer=this.removeDirectPhotographer.bind(this);
            this.removeDisabledDays=this.removeDisabledDays.bind(this);
            this.detectPrevButtonEvent=this.detectPrevButtonEvent.bind(this);
            this.detectNextButtonEvent=this.detectNextButtonEvent.bind(this);
            this.todaySelectorObject=null;
    }
    componentDidMount(){
        datePicker();//////////finaly show date span when map is initialized
        this.detectPrevButtonEvent();
        this.detectNextButtonEvent();

        if($( ".days div:last-child" ).children().first().attr('class')=='nul cell ')
            $( ".days" ).children().last().remove();

        let calendar=$('.days');
        let now = new Date();
        let thisHour = now.getHours();

        if(thisHour>18)
        {
            $('.days').find('.today').addClass('disday');
        }
        this.todaySelectorObject=$('.days').find('.today');
        $('.days').find('.today').removeClass('today');
        $('.days').find(".selday").removeClass('selday');


        let figure=$('#time-picker').find('figure');
        $( "#date_field" ).on("change", (changeEvt)=> {//day selection event
            if ($( ".selday" ).hasClass('disday'))//although the day is disabled but still is clickable, fixing this bug
            {
                $('div[data-gdate='+JSON.stringify(changeEvt.target.value.replace(/-0+/g, '-').replace(/-/g, "/"))+']').removeClass('selday');//css making blue again the previous selected day
                if(this.state.dateSelected!=="" && this.state.dateSelected!==changeEvt.target.value)
                {
                    $('div[data-gdate='+JSON.stringify(this.state.dateSelected.replace(/-0+/g, '-').replace(/-/g, "/"))+']').addClass('selday');
                }
                return;
            }

            let monthInt = parseInt(now.getMonth())+1;
            let monthStr = monthInt.toString();
            let dayStr = now.getDate();
            let dayInt = parseInt(now.getDate());

            let twoLengthMonth = (monthInt < 10) ? '0' + monthStr : monthStr;
            let twoLengthDay = (dayInt < 10) ? '0' + dayStr : dayStr;

            let thisDate = now.getFullYear()+"-"+twoLengthMonth+"-"+twoLengthDay;
            if(thisDate===changeEvt.target.value && $('.days').find('.today').hasClass( "disday" ))
                return;
            this.setState({dateSelected:changeEvt.target.value});
            this.props.dateSelectedCallBack(true);
            ////
            //$('#time-picker').addClass('hidden');
            let target = $('#time-picker figure .times ul');
            if(target.length)
                target.css('display','none');
            $('#noHoursSpan').css('display', 'none');
            ////
            this.setState({isTimeSelected:false});
            figure.find('.times ul li').removeClass('selected');// remove before selected time
            this.callAvailableHoursApi();
        });
    }
    componentWillReceiveProps(nextProps){
        if(nextProps.isMapChanged!==this.props.isMapChanged)
        {
            //hide time when map is changed before the isMapChange state become false
            this.props.dateSelectedCallBack(false);
            this.setState({dateSelected:""});
            $('#time-picker').addClass('hidden');
            $('#noHoursSpan').css('display', 'none');
            this.setState({isTimeSelected:false});

        }
        if(nextProps.shootTypeSelectedId!==this.props.shootTypeSelectedId || nextProps.selectedServicePackageId!==this.props.selectedServicePackageId)
        {
            //////////hide time when shoot type or package id are changed
            this.setState({dateSelected:""});
            this.props.dateSelectedCallBack(false);
            $('#time-picker').addClass('hidden');
            this.setState({isTimeSelected:false});
        }
        if(nextProps.whenWhereFieldValues!==this.props.whenWhereFieldValues)
        {
            this.setState({whenWhereFieldValues:nextProps.whenWhereFieldValues});
            if(nextProps.whenWhereFieldValues.unAvailablePhotographerDays  && !this.state.directPhotographerDeleted)
            {

                if((!this.props.whenWhereFieldValues.unAvailablePhotographerDays) || (nextProps.whenWhereFieldValues.unAvailablePhotographerDays !=this.props.whenWhereFieldValues.unAvailablePhotographerDays.length))
                {
                    if(nextProps.whenWhereFieldValues.unAvailablePhotographerDays.length==0)
                    {
                        this.setState({unAvailablePhotographerDays:nextProps.whenWhereFieldValues.unAvailablePhotographerDays},()=>{                         
                            this.removeDisabledDays();
                        });
                    }
                    else{
                        this.setState({unAvailablePhotographerDays:nextProps.whenWhereFieldValues.unAvailablePhotographerDays},()=>{
                            this.updateDisableDays();
                        });  
                    }
                    
                }
            }
        }
        this.setState({photographerUid:nextProps.photographerUid});

    }
    detectPrevButtonEvent(){
        $( ".prevArrow" ).on("click", (event)=> {
            event.preventDefault();
            if(event.currentTarget.className.includes("disabled"))
                return;
            ///reset date and time
            let now = new Date();
            let thisHour = now.getHours();


            if(thisHour>18)
            {
                $('.days').find('.today').addClass('disday');
            }
            $('.days').find('.today').removeClass('today');
            $('.days').find(".selday").removeClass('selday');

            if(this.state.dateSelected!=="")
            {
                this.props.dateSelectedCallBack(false);
                this.setState({dateSelected:""});
            }
            $('#time-picker').addClass('hidden');
            $('#noHoursSpan').css('display', 'none');
            if(this.state.isTimeSelected)
                this.setState({isTimeSelected:false});
            if(this.state.unAvailablePhotographerDays.length>0)
                this.updateDisableDays();

            this.detectNextButtonEvent();
            this.detectPrevButtonEvent();
        });
    }
    detectNextButtonEvent(){
        $( ".nextArrow" ).on("click", (event)=> {
            event.preventDefault();
            if(event.currentTarget.className.includes("disabled"))
                return;
            ///reset date and time
            let now = new Date();
            let thisHour = now.getHours();

            if(thisHour>18)
            {
                $('.days').find('.today').addClass('disday');
            }
            $('.days').find('.today').removeClass('today');
            $('.days').find(".selday").removeClass('selday');

            if(this.state.dateSelected!=="")
            {
                this.props.dateSelectedCallBack(false);
                this.setState({dateSelected:""});
            }
            $('#time-picker').addClass('hidden');
            $('#noHoursSpan').css('display', 'none');
            if(this.state.isTimeSelected)
                this.setState({isTimeSelected:false});
            if(this.state.unAvailablePhotographerDays.length>0)
                this.updateDisableDays();

            this.detectPrevButtonEvent();
            this.detectNextButtonEvent();

        });
    }
    callDirectPhotographerMissedApi(){
        let body="direct_photographer_missed="+this.props.photographerUid+"&project_slug="+this.props.project_slug;
        let url=this.props.link+'/api/v2/switched_direct_photographer';

        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .catch(function(e){console.log(e)});
    }
    callAvailablePhotographerApi(){
        let available_photographers=[];
        let error_messages = {};
        let body="photographer[date]="+this.state.dateTimeSelected+"&project_slug="+this.props.project_slug;

        let url=this.props.link+'/api/v2/available_photographer';

        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded" }})
            .then((response)=>{

                if (parseInt(response.status) != 202) {
                    response.json().then((object) =>{
                        console.log("response error:");
                        console.log(object);
                        error_messages["available_photographer_failure"] = object.messages;
                        this.setState({error_messages: error_messages});
                    });

                }
                else{

                    response.json().then((object) =>{
                        this.setState({wait:false});
                        if(object.data.length==0)
                        {
                            $('#availablePhotographerFailureSpan').css('display', 'block');   
                            error_messages["available_photographer_failure"] = "هیچ عکاس با شرایط انتخابی تان پیدا نشد";
                            this.setState({error_messages: error_messages});
                            let target = $('#availablePhotographerFailureSpan');
                            if( target.length ) {
                                $('html, body').stop().animate({
                                    scrollTop: target.offset().top
                                }, 1000);
                            }

                        }
                        else{
                            object.data.map((item) =>{
                                available_photographers.push(item);
                            });
                            $('#availablePhotographerFailureSpan').css('display', 'none');   
                            this.props.availablePhotographers(available_photographers);
                            this.setState({isTimeSelected:true});
                            this.props.nextStep();
                        }


                    });

                }



            })
            .catch(function(e){console.log(e)});
    }
    callAvailableHoursApi(){
        let directAndPhotographerSelected= (!this.state.directPhotographerDeleted)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
        let available_hours=[];
        let error_messages = {};
        let body="free_time[date]="+this.state.dateSelected+"&free_time[shoot_type]="+this.props.shootTypeSelectedId+"&free_time[package_id]="+this.props.selectedServicePackageId+"&project_slug="+this.props.project_slug+(directAndPhotographerSelected? "&photographer="+this.props.photographerUid : '');
        let url=this.props.link+'/api/v2/available'+(directAndPhotographerSelected ? '_photographer' : '')+'_hours';
        this.setState({wait:true});
        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{
                if (parseInt(response.status) != 202) {

                    response.json().then((object) =>{
                        $('#noHoursSpan').css('display', 'block');
                        error_messages["available_hours_failure"] = object.messages;
                        this.setState({error_messages: error_messages});
                    });
                }
                else{
                    response.json().then((object) =>{
                        this.setState({wait:false});
                        if(object['response']=='nok')
                        {
                            $('#time-picker').addClass('hidden');
                            $('#noHoursSpan').css('display', 'block');
                            error_messages["available_hours_failure"] = "متاسفانه در این مکان و زمان عکاسی فعال نیست. جهت هماهنگی با نزدیک ترین عکاس فعال ( با احتساب حداقل هزینه رفت و آمد ) با شماره ۰۲۱-۲۸۴۲۵۲۲۰ تماس بگیرید.";
                            this.setState({error_messages: error_messages});
                            let target = $('#noHoursSpan');
                            if( target.length ) {
                              $('html, body').stop().animate({
                                  scrollTop: target.offset().top
                              }, 1000);
                            }
                        }
                        else{
                            let now = new Date();
                            let thisDay = now.getDate();
                            let thisHour = now.getHours();
                            let unAvailableHours = [];
                            unAvailableHours = this.getListOfUnAvailableHours(thisHour);
                            let unAvailableNextHours = [];
                            unAvailableNextHours= this.getListOfNextUnAvailableHours(thisHour,6);//create a list of next n hours
                            object["result"].map((item) =>{
                                //
                                if(thisDay==this.state.dateSelected.split('-')[2])
                                {

                                    if(unAvailableHours.includes(item.time_name))
                                    {
                                        item.times=[];//remove the whole items from that period of daylight
                                    }
                                    else{
                                        //search into result available times and parse and translate to english number and detect next n hours and remove them
                                        //first detect target removing hour indexes
                                        let targetIndexes=[];
                                        item.times.map((item1,i)=>{
                                            let itemEnglishHour=parseInt(item1.substring(0, item1.indexOf(':')).toEnglishDigits());
                                            if(unAvailableNextHours.includes(itemEnglishHour) || thisHour>itemEnglishHour)
                                            {
                                                targetIndexes.push(i);
                                            }
                                        });

                                        //second iterate over index and remove target hours
                                        for (var i = targetIndexes.length -1; i >= 0; i--)
                                        {
                                            item.times.splice(targetIndexes[i], 1);
                                        }
                                        if(item.times.length==0){
                                            $('#time-picker').addClass('hidden');
                                            $('#noAvailableHoursSpan').css('display', 'block');
                                            error_messages["no_available_hours_failure"] = "متاسفانه امروز امکان رزرو عکاس وجود ندارد. امکان رزرو از فردا وجود دارد.";
                                            this.setState({error_messages: error_messages});
                                            let target = $('#noAvailableHoursSpan');
                                            if( target.length ) {
                                              $('html, body').stop().animate({
                                                  scrollTop: target.offset().top
                                              }, 1000);
                                            }
                                            available_hours=[];
                                            return;
                                        }
                                    }
                                }
                                available_hours.push(item);


                            });
                            if(available_hours.length!=0)
                            {
                                this.setState({availableHours: available_hours},()=>{
                                    $('#time-pick').removeClass('hidden');
                                    $('#time-picker').removeClass('hidden');
                                    let target = $('#time-picker figure .times ul');
                                    if(target.length)
                                        target.css('display','block');

                                    $('#noHoursSpan').css('display', 'none');
                                    $('#noAvailableHoursSpan').css('display', 'none');
                                    if(window.innerWidth<970)
                                    {
                                        let target = $('#time-pick');
                                        if( target.length ) {
                                          $('html, body').stop().animate({
                                              scrollTop: target.offset().top
                                          }, 1000);
                                        }
                                    }
                                });
                            }
                        }


                    });

                }



            })
            .catch(function(e){console.log(e)});
    }
  handleSubmitButton(){
    this.setState({isTimeSelected:false});
    this.setState({wait:true});
    this.callAvailablePhotographerApi();
    let data = {
        dateSelected:this.state.persianDateTimeData.dateSelected,
        timeSelected:this.state.persianDateTimeData.timeSelected,
        dateTimeSelected:this.state.dateTimeSelected,
    };
    this.props.whenFieldValues(data);
  }
  updateDisableDays(){
    let disabledDayLocations=[];
    $('.days').children().map((i,item) =>{
        $(item).children().map((j,item1) =>{
            if(!( $(item1).hasClass("disday") || $(item1).hasClass("nul")))
            {
                let disabledDayLocation={};
                if(this.state.unAvailablePhotographerDays.includes(j+1))
                {
                    disabledDayLocation={i:i,j:j}
                    $(item1).addClass('disday');
                    disabledDayLocations.push(disabledDayLocation);
                }
            }
        });
    });
    if((this.state.unAvailablePhotographerDays.length>0 && disabledDayLocations.length>0) || (this.state.unAvailablePhotographerDays.length==0  && disabledDayLocations.length==0) )
        this.setState({disabledDayLocations:disabledDayLocations});

  }
  getListOfUnAvailableHours(hour){
    if(hour<12)
    {
        return ['صبح'];
    }
    else if(hour<16)
    {
        return ['صبح' , 'ظهر'];
    }
    else{
       return ['صبح' , 'ظهر'];
    }
  }
  getListOfNextUnAvailableHours(hour,n){
    let unAvailableNextHours = [];
    for (var i = 0; i < n; i++) {
        if(hour+i<24)
        {
            unAvailableNextHours.push(hour+i);
        }
        else{
            unAvailableNextHours.push(hour+i-24);
        }
    }
    return unAvailableNextHours;
  }
  removeDirectPhotographer(){
    this.setState({directPhotographerDeleted:true});
    this.props.removeDirectPhotographerCallBack(true);
    ///reset date and time
    this.props.dateSelectedCallBack(false);
    this.setState({dateSelected:""});
    $('#time-picker').addClass('hidden');
    $('#noHoursSpan').css('display', 'none');
    this.setState({isTimeSelected:false});
    ///
    ///remove photographer uid or shoot location from url
    let url = window.location.href;
    
    let index1=url.indexOf("&photographer=");
    let index2=url.indexOf("shoot_location=");
    let newUrl="";


    if(index1!=-1)//if we have photographer in link
    {       
        newUrl=url.substring(0, index1);
    }
    else if(index2!=-1)
    {
        newUrl=url.substring(0, index2-1);
    }
    
    window.history.pushState({path:newUrl},'',newUrl);

    ///
    if(this.props.photographerUid!=-1)
        this.callDirectPhotographerMissedApi();
    this.removeDisabledDays();
    if(this.props.studioSelected)
        this.props.previousStep();
  }
  removeDisabledDays(){
    $('.days').children().map((i,item) =>{
        $(item).children().map((j,item1) =>{
            if(this.state.disabledDayLocations.some(function(o){return (o.i === i) && (o.j === j)}))
                $(item1).removeClass('disday')
        });
    });
    this.setState({unAvailablePhotographerDays:[]});
    this.setState({disabledDayLocations:[]});

  }
  render () {

   /* if(this.state.isMapChanged)
    {

        return(
            <div id="calendar" className="wrapper calendar">
            </div>
        );
    }
    else{*/
        let photographerInfo = <React.Fragment></React.Fragment>;
        let directAndPhotographerSelected= (!this.state.directPhotographerDeleted)?(this.state.photographerUid!==''):false;
        if( this.state.dateSelected=="")
        {
            $(".day.cell").removeClass("selday");//remove selected date by default
        }
        if(directAndPhotographerSelected && this.state.whenWhereFieldValues.photographerName && this.state.whenWhereFieldValues.avatarUrl)
            photographerInfo=<div className="col-sm-12 alert alert-success">
                                <div className="col-sm-2">
                                    <div className="photographer-info-img" style={{cursor: 'pointer', backgroundImage: 'url('+(this.state.whenWhereFieldValues.avatarUrl)+')'}}></div>
                                </div>
                                <div className="col-sm-8 text-center date-header-text-info">
                                    {'شما در حال انتخاب زمان از تقویم کاری '+(this.state.whenWhereFieldValues.photographerName)+' هستید.'}
                                    <br />
                                    {'برای مشاهده زمان های بیشتر، اجازه دهید کادرو به شما عکاس معرفی کند.'}
                                </div>
                                <div className="col-sm-2">
                                    <button className="btn btn-success remove_photographer_btn btn-block" onClick={this.removeDirectPhotographer} >
                                    معرفی کن
                                    </button>
                                </div>
                            </div>;
        else{
            photographerInfo=<React.Fragment></React.Fragment>;
        }
        return (
            <React.Fragment>
                <div className="container">
                    <div className="main">
                        <div className="wrapper">
                            {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                            <input type="hidden" name="date" id="date_field" value=''/>
                            <input type="hidden" name="time" id="time" value=''/>
                            <div id="calendar" className="wrapper calendar">
                                <div className="row">
                                    <div className="col-sm-12">
                                        {photographerInfo}
                                        <div className="alert alert-danger" id="noAvailableHoursSpan" style={{ display: "none", textAlign: "center" }}>
                                            <p style={{ color: "red",textDecoration: 'none' }}>{this.state.error_messages["no_available_hours_failure"]}</p>
                                        </div>
                                        <div className="alert alert-danger" id="noHoursSpan" style={{ display: "none", textAlign: "center" }}>
                                            <p style={{ color: "red",textDecoration: 'none' }}>{this.state.error_messages["available_hours_failure"]}</p>
                                            <div style={{textAlign: 'center', marginTop: '0.8rem'}}>{(mobileDisplay)?(<button className="btn btn-alert btn-large btn-lg =" onClick={()=>{event.preventDefault();window.open("tel:0212842522")}} >
                                            تماس با ما</button>):(<button className="btn btn-alert btn-large btn-lg =" onClick={()=>{event.preventDefault();window.open("https://www.kadro.co/contact")}} >
                                            تماس با ما</button>)}</div>
                                        </div>
                                        <div className="alert alert-danger" id="addressErrorSpan" style={{ display: "none", textAlign: "center"}}>
                                            <p style={{ color: "red",textDecoration: 'none' }}>{this.state.error_messages["submit_address"]}</p>
                                        </div>
                                        <div className="alert alert-danger" id="availablePhotographerFailureSpan" style={{ display: "none" ,textAlign: "center"}}>
                                            <span style={{color: 'red'}}>{this.state.error_messages["available_photographer_failure"]}</span>
                                        </div>
                                    </div>
                                    <div className="col-sm-6">
                                        <label>
                                            روز و ساعتی که می خواهید را انتخاب کنید:
                                        </label>

                                        <span id="date-picker" > </span>
                                    </div>
                                    <div id="time-pick" className="col-sm-6 hidden">
                                        <label>
                                            بازه های زمانی قابل انتخاب برای شما:
                                        </label>
                                        <div id="time-picker" className="hidden">

                                            <header className="gdate"></header>
                                            <figure className="row row-m0">
                                                <AvailableHoursTab
                                                availableHours={this.state.availableHours}
                                                isTimeSelected={(id) => this.setState({isTimeSelected:id})}
                                                dateTimeSelected={(id) => this.setState({dateTimeSelected:id})}
                                                dateSelected={this.state.dateSelected}
                                                persianDateTimeData_callBack={(id) => this.setState({persianDateTimeData:id})}
                                                />

                                            </figure>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <br />
                            <div className="row full-continue-btn">
                                <div className="col-sm-4 col-sm-offset-4">
                                    <ContinueButton
                                    handleSubmitButton={this.handleSubmitButton}
                                    continueButtonDisabled={!this.state.isTimeSelected}
                                    wait={this.state.wait}
                                    payment={false}
                                    />
                                </div>
                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
                                <br />
                                {/*<Tracker
                                    step={this.props.step}
                                />*/}
                            </div>
                            <br />
                        </div>

                    </div>

                </div>
                <BookFooter
                    backButtonDisabled={false}
                    previousStep={this.props.previousStep}
                    handleSubmitButton={this.handleSubmitButton}
                    continueButtonDisabled={(!this.state.isTimeSelected)}
                    wait={this.state.wait}
                    payment={false}
                />
                <WaitingPopup wait={this.state.wait}/>
            </React.Fragment>
        );
   /* }*/
  }
}
