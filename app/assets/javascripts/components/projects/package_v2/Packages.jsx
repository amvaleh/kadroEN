
class Packages extends React.Component {

    constructor(props) {
        super(props);
        this.state = {
            hours: [],
            activeHour: props.recommendationIndex,
            recommendationIndex: props.recommendationIndex,
            receiveType:'online-gallery',
            modalData: null,
            packages: [],
            packageIdSelected:-1,

        }
        this.scrollToSelectedHour = this.scrollToSelectedHour.bind(this);
        this.selectPackage = this.selectPackage.bind(this);
    }

    componentDidUpdate(){
        if(mobileDisplay)
            this.scrollToSelectedHour();
    }
    scrollToSelectedHour(){
        const target = $(`[hour=${this.state.activeHour}]`);
        const container = target.parent();
        var targetPosition = 100
        if (target.selector !== "[hour=0]") {
            targetPosition = target.position().left;
        }
        const targetWidth = target.width();
        const containerWidth = container.width();
        const scrollBarPosition = container.scrollLeft();
        const targetOffset = scrollBarPosition + targetPosition - containerWidth/2 + targetWidth/2;
        container.animate({
            scrollLeft: targetOffset
        }, 500);
    }
    componentWillReceiveProps(nextProps){
  
    if(nextProps.receiveType!==this.props.receiveType || nextProps.packages!==this.props.packages)
    {
      this.setState({receiveType:nextProps.receiveType});
      let newPackages = [...nextProps.packages];
        let hours = newPackages.map(item => {
            return item.order
        });
        let sortedPackages = newPackages.sort((a, b) => {
            if (a.order_in_duration < b.order_in_duration) {
                return -1;
            }
            if (a.order_in_duration > b.order_in_duration) {
                return 1;
            }

            // names must be equal
            return 0;
        });

        let hoursSet = [... new Set(hours)];
        this.setState({ hours: hoursSet, packages: sortedPackages });
        this.setState({ activeHour: nextProps.recommendationIndex });
        
        hoursSet.sort().map((item,index) => {
            if(nextProps.recommendationIndex ==item)
            {
                this.setState({recommendationIndex:item})
            }
        })

    }
    if(nextProps.wait!==this.props.wait)
    {
      this.setState({wait:nextProps.wait});
    }
  }
  selectPackage(selectedPackage){
    this.setState({packageIdSelected:selectedPackage.id});
    var data={
        id:selectedPackage.id,
        title:selectedPackage.title,
        duration:toPersianNumber(selectedPackage.order)+' ساعت',
        is_full:selectedPackage.is_full,
        digitals:selectedPackage.digitals,
        price:selectedPackage.price,
    }
    /*
    this.props.servicePackageSelectedData_callBack(data);
    this.props.isServiceSelected_callBack1(true);
    */
    this.props.handleDirectSubmitButtonCallBack(data);
    //this.handleCallSubmitServicePackageApi();
  }
  handleClickOnHour(item){
    this.setState({ activeHour: item })
  }
render() {
    return (
        <div className='packages'>
            {/*<h2><small>تعرفه قیمت عکاسی</small><br /><b>{`چهره - پروفایل`}</b></h2>

            <div className="options">
                <div className="item">
                    <img src="" alt="" className="icon" />
                    <p >برای عکاسی پوشاک و لباس <b> تعرفه‌های 3 ساعته بیشترین خرید را داشته است.</b></p>
                </div>

                <div className="item">
                    <img src="" alt="" className="icon" />
                    <p >قیمت در شهرستان‌ها با تخفیف ثابت همراه است.</p>
                </div>

            </div>
            */}
            <h4>انتخاب کنید<b> پروژه‌تون چند ساعت وقت میبره؟ </b></h4>


            <div className="selection-bar">
                {
                    this.state.hours.sort().map((item,index) => {
                        return (
                            <div
                                key={index}
                                hour={item}
                                className={this.state.activeHour == item ? "item-select active " : "item-select"}
                                onClick={this.handleClickOnHour.bind(this,item)}
                            >
                                <div className={this.state.activeHour == item ? "circle active " : "circle "} />
                                <p>{item} ساعت</p>
                                <img src='img/Verify.svg' alt="" className="popular-icon" style={{ display: item == this.state.recommendationIndex ? 'block' : 'none' }} />

                            </div>
                        )
                    })
                }
            </div>

            <div className="packages-cards">
                {
                    this.state.packages.map((item,i) => {
                        return (
                            <PackageCard key={i} data={item} selected={this.state.packageIdSelected==item.id} activeHour={this.state.activeHour} receiveType={this.state.receiveType} onModal={item => { this.setState({ modalData: item }) }} selectPackageCallBack={(id)=>{this.selectPackage(id)}}/>
                        )
                    })
                }
            </div>


            <div className="options bg-blue">
                <div className="item">
                    <img src="" alt="" className="icon" />
                    <p >مشاهده <b> همه عکس‌ها</b></p>
                </div>
                <div className="item">
                    <img src="" alt="" className="icon" />
                    <p >هزینه هر نیم ساعت عکاسی اضافه،  <b>{this.props.halfHour} تومان</b> است.</p>
                </div>

            </div>
            <Modal buttonTitle={"اطلاعات بیشتر ..."}
                data={this.state.modalData}
                onClose={e => { this.setState({ modalData: e }) }}
            />

        </div>
    )
}
}
