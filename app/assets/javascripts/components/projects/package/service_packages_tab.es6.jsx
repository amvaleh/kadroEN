class ServicePackagesTab extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      servicePackageSelectedId: '',
      isServiceSelected:false,
      servicePackageSelectedIndex:-1,
      hourSelectedIndex:props.recommendationIndex,
      hourSelectedPackages:[],
      hours:props.hours,
      ticks:props.ticks,
      lengthOfPackages:props.length_of_packages,
      servicePackages:props.service_packages,
      wait:false,
      recommendationIndex:props.recommendationIndex,
      showEconomyPackages:false,
      receiveType:props.receiveType,
    };

    this.handleClickServicePackage=this.handleClickServicePackage.bind(this);
    this.getServicePackagesFromHourSelectedIndex=this.getServicePackagesFromHourSelectedIndex.bind(this);
    this.setServicePackageInformationsFromId=this.setServicePackageInformationsFromId.bind(this);
    this.selectStandardPackageByHour=this.selectStandardPackageByHour.bind(this);
    this.infoButtonClick=this.infoButtonClick.bind(this);
    this.checkThisHourHasEconomicPackages=this.checkThisHourHasEconomicPackages.bind(this);
  }
  selectStandardPackageByHour()
  {
    $("div[hourindex="+(this.state.hourSelectedIndex)+"][isfull=true]").css("display","");
    // $("div[hourindex="+(this.state.hourSelectedIndex)+"][isfull=true]").addClass("selected");
    let index = parseInt($("div[hourindex="+(this.state.hourSelectedIndex)+"][isfull=true]").attr('index'));
    let id=$("div[hourindex="+(this.state.hourSelectedIndex)+"][isfull=true]").attr('data-value');
    this.setState({servicePackageSelectedIndex:index});
    this.setState({servicePackageSelectedId: id}, () =>
    {

      this.props.selectedServicePackageIdCallBack(this.state.servicePackageSelectedId);
      this.setServicePackageInformationsFromId(this.state.servicePackageSelectedId);
    }
    );
    this.setState(
      {isServiceSelected: true}, () =>
      {

        this.props.isServiceSelected_callBack1(this.state.isServiceSelected);

      }
    );
}
getServicePackagesFromHourSelectedIndex(index){
  // this.state.selectedServicePackageIndex -> this.state.selectedServicePackageId

  let resultPackages=[];
  this.state.servicePackages
  .map((object)=>{

    object.map((item,i)=>{
      if(i==index)
      {

        //preparing for receipt page show package informations
        resultPackages.push(item);

      }
    })
  });

  return resultPackages;
}
setServicePackageInformationsFromId(id){
  let returnPackageId='';
  for (var i = this.state.servicePackages.length - 1; i >= 0; i--) {
    for (var j = this.state.servicePackages[i].length - 1; j >= 0; j--) {
      if(this.state.servicePackages[i][j].id==id){

        returnPackageId=this.state.servicePackages[i][j].id;
        var data={
          title:this.state.servicePackages[i][j].title,
          duration:this.state.servicePackages[i][j].duration,
          is_full:this.state.servicePackages[i][j].is_full,
          digitals:this.state.servicePackages[i][j].digitals,
          price:this.state.servicePackages[i][j].price,
        }
        this.props.servicePackageSelectedData_callBack(data);
      }
    }
  }

}
handleClickServicePackage(event)
{
  // updateRadiusAroundMarker(parseInt(event.currentTarget.getAttribute('rational')) * 1000);
  this.setState({servicePackageSelectedIndex: parseInt(event.currentTarget.getAttribute('index')) });
  this.setState(
    {servicePackageSelectedId: event.currentTarget.getAttribute('data-value')}, () =>
    {

      this.props.selectedServicePackageIdCallBack(this.state.servicePackageSelectedId);
      this.setServicePackageInformationsFromId(this.state.servicePackageSelectedId);
    }
  );
  this.setState(
    {isServiceSelected: true}, () =>
    {

      this.props.isServiceSelected_callBack1(this.state.isServiceSelected);

    }
  );


}

componentDidMount(){
  $(".service_package").css("display","none");
  this.selectStandardPackageByHour();

  let Slider=$("#ex6");
  Slider.slider();
  var change_count=0;
  Slider.on("change", (slideEvt)=> {
    let slider_value=slideEvt.value;
    this.setState({hourSelectedIndex: slider_value.newValue },()=>{
      this.selectStandardPackageByHour();
    });
    change_count = change_count + 1;
    if (change_count>5){
      setTimeout( function(){
        $('.btn-lower-prices').fadeIn("slow");
      },1000);
    };
  });
  setTimeout( function(){
    $('.btn-lower-prices').fadeIn("slow");
  },30000);
}
componentWillReceiveProps(nextProps){
  
    if(nextProps.receiveType!==this.props.receiveType || nextProps.service_packages!==this.props.service_packages)
    {
      this.setState({receiveType:nextProps.receiveType});
      this.setState({hours:nextProps.hours},()=>{
        this.setState({ticks:nextProps.ticks},()=>{
          this.setState({lengthOfPackages:nextProps.length_of_packages},()=>{
            this.setState({servicePackages:nextProps.service_packages},()=>{
              $("#ex6").slider('destroy');
              $("#ex6").slider();
              this.setState({hourSelectedIndex:nextProps.recommendationIndex},()=>{
                $("#ex6").slider('setValue', this.state.hourSelectedIndex, true);
                this.selectStandardPackageByHour();

                $("#ex6").on("change", (slideEvt)=> {
                  let slider_value=slideEvt.value;
                  this.setState({hourSelectedIndex: slider_value.newValue },()=>{
                    this.selectStandardPackageByHour();
                  });

                });
              });

            });
          });
        });
      });


    }
    if(nextProps.wait!==this.props.wait)
    {
      this.setState({wait:nextProps.wait});
    }


  }
  componentDidUpdate(){

    $(".service_package").css("display", "none");

    if(!this.state.showEconomyPackages)
    $("div[hourindex="+(this.state.hourSelectedIndex)+"][isfull=true]").css("display", "");
    else
    $("div[hourindex="+(this.state.hourSelectedIndex)+"]").css("display", "");

  }
  checkThisHourHasEconomicPackages(){
    for (var i = 0; i < this.state.servicePackages[this.state.hourSelectedIndex].length; i++) {
      if(this.state.servicePackages[this.state.hourSelectedIndex][i].is_full==false)
        return true;

    }
    return false;
  }
  infoButtonClick(event){
    var target=$(event.target.getAttribute('data-target'))
    if( target.length ) {
      $('html, body').stop().animate({
        scrollTop: target.offset().top
      }, 1000);
    }
  }
  render(){
    let tempSelectedPackageIndex='';
    let sliderBarWidth=(180*(this.state.lengthOfPackages-1));
    let icon_url = "",description="",category="";
    let extendedHourCost = toPersianNumber(makeDottedNumber(parseInt(this.props.shootTypeSelectedExtendedHourCost)));
    let packageItems= this.state.servicePackages
    .map((object,i)=>{
      return (
        object.map((item,j)=>{
          let has_features;
          let gp_back;
          let gp_color;
          let real_price;
          if (item['vip']){
            gp_back= '#d2b103';
            gp_color= 'white';
          }
          let feature_2;
          let feature_3;
          let feature_4;
          let feature_5;
          let feature_6;
          let feature_7;
          if (item['feature_2']){
            feature_2 =
            <p><span className="fa fa-star"></span> {item['feature_2']}</p>
          }
          if (item['feature_3']){
            feature_3 =
            <p><span className="fa fa-star"></span> {item['feature_3']}</p>
          }
          if (item['feature_4']){
            feature_4 =
            <p><span className="fa fa-star"></span> {item['feature_4']}</p>
          }
          if (item['feature_5']){
            feature_5 =
            <p><span className="fa fa-star"></span> {item['feature_5']}</p>
          }
          if (item['feature_6']){
            feature_6 =
            <p><span className="fa fa-star"></span> {item['feature_6']}</p>
          }
          if (item['feature_7']){
            feature_7 =
            <p><span className="fa fa-star"></span> {item['feature_7']}</p>
          }
          if (item['feature_2'] || item['feature_3'] || item['feature_4']){
            has_features = <div className="text-right package_features" >
              <p style={{marginBottom: '15px'}}>
              موارد افزوده:
              </p>
              {feature_2}
              {feature_3}
              {feature_4}
              {feature_5}
              {feature_6}
              {feature_7}
            </div>;
          }
          if (item.is_full)
          {
            description=item['description1'];
            icon_url = "/img/high-book.png";
            if (item['name']){
              category=item['name'];
            }
            else
            {
              category="استاندارد";
            }
          }
          else{
            description=item['description'];
            icon_url = "/img/low-book.png";
            if (item['name']){
              category=item['name'];
            }
            else
            {
              category="اقتصادی"
            }
          }
          if (item['real_price']){
            real_price = <p style={{color: "#7baaff"}}>
            <span className="" > ارزش واقعی: </span>
            <span className="" style={{fontSize: "30px", textDecoration: "line-through"}}>{toPersianNumber(makeDottedNumber(item['real_price']))}
            </span>
            تومان
            </p>
          }
          return (
            <div
            className={"block service_package "+((this.state.servicePackageSelectedIndex===j)? 'selected':'')}
            key={j}
            hourindex={i}
            index={j}
            data-value={item['id']}
            onClick={this.handleClickServicePackage}
            title={item['title']}
            rational={item['rational_distance']}
            duration={item['duration']}
            digitals={item['digitals']}
            isfull={(item["is_full"])?'true':'false'}
            style={{marginTop: '1%',fontFamily: "iranyekan"}}
            >
              <div className="col-xs-12" style={{lineHeight:'initial'}}>
                <span className="text-right package_name" style={{background: gp_back, color: gp_color}}>
                {category}
                </span>
                <p className="text-right package_cap">
                {(item['duration']) + " عکاسی حرفه ای و "}
                {description}
                </p>
                <p className="text-right " style={{fontSize: "0.8rem"}}>
                <span style={{fontStyle:"italic",color:"black"}}>میانگین </span>{" "+toPersianNumber(item['feature_1'])+ " عکس نهایی "}
                در سفارش های قبلی تحویل داده شده است.
                <a tabIndex="0" id={"element"+item['id']} className="pull-left" role="button" data-toggle="popover" style={{fontSize: '11px'}} data-trigger="focus" data-placement="right"  title="یعنی چه؟"
                data-content={"*میانگین "+toPersianNumber(item['feature_1'])+" عدد عکس نهایی در سفارش های قبلی این پکیج تحویل داده شده است. (با ادیت نور و رنگ)، متناسب با نیاز شما، کمی بیشتر یا کمتر از همین تعداد عکس دریافت خواهید کرد."}  onClick={ (e)=>{e.preventDefault();$("#element"+item['id']).popover('show')} }>
                <span style={{color: 'gray',fontSize: "0.8rem"}} className="fa fa-info-circle">{" توضیح "}</span>
                </a>
                </p>
                <p className="text-left package_total">
                {real_price}
                <span className="" > قیمت: </span>
                <span className="" style={{fontSize: "30px"}}>{toPersianNumber(makeDottedNumber(item['price']))}
                </span>
                 تومان
                </p>
                {has_features}

              </div>
            </div>
          );
        })
      );

    });
    let showEconomyPackages=false;
    if(this.state.receiveType=='online-gallery')
    {
      if(this.state.servicePackages){
        if(this.state.servicePackages.length>0)
        {
          showEconomyPackages=this.checkThisHourHasEconomicPackages();
        }
      }
    }
    return(
      <div>

      <input id="ex6" type="text"
      className="shoot hidden-xs hidden-sm"
      data-slider-min="0"
      data-slider-max={this.state.lengthOfPackages-1}
      data-slider-step="1"
      data-slider-value={this.state.hourSelectedIndex}
      data-slider-tooltip="hide"
      data-interval="500"
      data-slider-ticks={this.state.ticks}
      data-slider-ticks-labels={this.state.hours}
      style={{width: ((sliderBarWidth<992)?sliderBarWidth:991) , marginRight: 'auto' , marginLeft: 'auto' }}
      />
      <div className="shoot-packages-boxes" >
      <ul id='packs'>
      {packageItems}
      </ul>
      </div>


      {(showEconomyPackages)?<div className="row">
      <div className="col-sm-4 col-sm-offset-4 text-center"><button className="economy-show btn btn-default" style={{display:(this.state.showEconomyPackages)?'none':'block'}} onClick={(event)=>{event.preventDefault();this.setState({showEconomyPackages:true})}} >
      {'پکیج های ارزانتر'}
      </button></div></div>:<React.Fragment></React.Fragment>}
      <div className="row full-continue-btn">
      <div className="col-sm-4 col-sm-offset-4">
      {(this.state.receiveType=='memory-plus')? <button className="btn btn-blue btn-block more-info-btn" type="button" data-toggle="collapse" data-target="#memory-plus-info" aria-expanded="false" aria-controls="memory-plus-info">
      <i className="fa fa-arrow-down"></i>جزئیات قیمتها
      </button>:
      <button className="btn btn-blue btn-block more-info-btn" type="button" data-toggle="collapse" data-target="#online-gallery-info" aria-expanded="false" aria-controls="online-gallery" onClick={this.infoButtonClick}>
      <i className="fa fa-arrow-down"></i>جزئیات قیمتها
      </button>}
      </div>
      </div>
      {this.props.info}
      <div className="row full-continue-btn">
      <div className="col-sm-4 col-sm-offset-4">
      <ContinueButton
      handleSubmitButton={this.props.handleSubmitButtonCallBack}
      continueButtonDisabled={!this.state.isServiceSelected}
      wait={this.state.wait}
      payment={false}
      />
      </div>
      <div id="more-notes" className="col-xs-12">
      <p className="pricing-notes">
      *
      هزینه <strong> تمدید </strong> هر نیم ساعت
      <span style={{color:'#31ce2e'}}>
      {' در رشته‌ی '+(this.props.shootTypeSelectedTitle)+', '+(extendedHourCost)+' تومان '}
      </span>
      است.
      </p>
      <p className="pricing-notes">
      *
      مدت عکاسی شامل زمان رسیدن عکاس به محل
      <strong style={{color:'#31ce2e'}}>
      {' نمی شود؛ '}
      </strong>
      اما زمان مورد نیاز برای راه اندازی و نصب تجهیزات عکاسی
      <strong style={{color:'#31ce2e'}}>
      {' جزو پکیج شما '}
      </strong>
      می باشد.
      </p>
      </div>
      </div>

      <br />

      {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
      {/* <Tracker
        step={this.props.step}
        />*/}
        <WaitingPopup wait={this.state.wait}/>
        </div>

      );
    }
  }
