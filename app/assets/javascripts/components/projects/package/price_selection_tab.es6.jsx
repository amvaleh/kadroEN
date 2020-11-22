class PriceSelectionTab extends React.Component {
	constructor(props) {
        super(props);
        this.state = {
            shoot_type_selected_id: '',
            galleryHours:[],
            memoryHours:[],
            galleryTicks:[],
            memoryTicks:[],
            privateGalleryOrderedPackages:[],
            memoryPlusOrderedPackagesLength:0,
            memoryPlusOrderedPackages:[],
            privateGalleryOrderedPackagesLength:0,
            recommendationGalleryIndex:0,
            recommendationMemoryIndex:0,
            receiveType:'online-gallery',
            wait:false,
        };
    }
    componentWillReceiveProps(nextProps){
        this.setState({galleryHours:nextProps.galleryHours});
        this.setState({memoryHours:nextProps.memoryHours});
        this.setState({galleryTicks:nextProps.galleryTicks});
        this.setState({memoryTicks:nextProps.memoryTicks});
        this.setState({privateGalleryOrderedPackages:nextProps.privateGalleryOrderedPackages});
        this.setState({memoryPlusOrderedPackagesLength:nextProps.memoryPlusOrderedPackagesLength});
        this.setState({memoryPlusOrderedPackages:nextProps.memoryPlusOrderedPackages});
        this.setState({privateGalleryOrderedPackagesLength:nextProps.privateGalleryOrderedPackagesLength});
        this.setState({recommendationGalleryIndex:nextProps.recommendationGalleryIndex});
        this.setState({recommendationMemoryIndex:nextProps.recommendationMemoryIndex});
        this.setState({receiveType:nextProps.receiveType});
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
        }
        if(nextProps.shoot_type_selected_id!==this.props.shoot_type_selected_id)
        {
          this.setState({shoot_type_selected_id:nextProps.shoot_type_selected_id});
        }
    }
  	render()
	{
        let memoryPlusInfo =<div className="collapse" id="memory-plus-info">
            <div className="row">
              <div className="col-xs-12 col-sm-4 col-md-6 well">
              همه عکسها را در محل تحویل بگیرید.
              </div>
              <div className="col-xs-12 col-sm-4 col-md-6 well">

              همه عکسها را در آلبوم خصوصی تان
              <strong> نیز میتوانید </strong>
              دریافت کنید.
              </div>
              <div className="col-xs-12 col-sm-4 col-md-6 well">
              امکان حذف همه عکسها از حافظه دوربین عکاس.
              </div>
              <div className="col-xs-12 col-sm-4 col-md-6 well">
              عکاس
              <strong style= {{color: "#2B87F9"}}> هر چند عکسی </strong>
              که بتواند میگیرد، بدون محدودیت در تعداد!
              </div>
              <div className="col-xs-12 col-sm-4 col-md-6 well">
               می توانید یکبار بدون هزینه زمان عکاسی را تغییر دهید.
              </div>
              <div className="col-xs-12 col-sm-4 col-md-6 well">
               روتوش حرفه ای هر عکس ۱۰ هزار تومان است.
              </div>
            </div>
      </div>;

    let onlineGalleryInfo = <div className="collapse" id="online-gallery-info">
        <div className="row">
            <div className="col-xs-12 col-sm-4 col-md-6 well">
            <strong style= {{color: "#2B87F9"}}>
            همه عکسهای &nbsp;
            </strong>
             شما ادیت استاندارد نور و رنگ می شوند.
            </div>
            <div className="col-xs-12 col-sm-4 col-md-6 well">
             همه عکسها رو می تونید در آلبوم خصوصی تان ببینید.
            </div>
            <div className="col-xs-12 col-sm-4 col-md-6 well">
            عکسها برای همیشه در آلبوم خصوصی تان آرشیو می شود.
            </div>
            <div className="col-xs-12 col-sm-4 col-md-6 well">
            عکاس
            <strong style= {{color: "#2B87F9"}}> هر چند عکسی </strong>
            که بتواند میگیرد، بدون محدودیت در تعداد!
            </div>
            <div className="col-xs-12 col-sm-4 col-md-6 well">
             می توانید یکبار بدون هزینه زمان عکاسی را تغییر دهید.
            </div>
            <div className="col-xs-12 col-sm-4 col-md-6 well">
             روتوش حرفه ای هر عکس ۱۰ هزار تومان است.
            </div>
          </div>
      </div>;
        let header=(!this.props.direct)?'۳- انتخاب قیمت':'۲- انتخاب قیمت';
        if(this.props.receiveType=="memory-plus"){

	        return(
	            <div id="packages" style={{margin: "5% 0 0 0"}}>
                            <div className="ball glowing col-xs-12 col-md-6 col-md-offset-3 btn-lower-prices">
                            <a id="lower_price" href="https://app.kadro.co/call_request">قیمت کمتر میخواهم</a></div>
	                <h3 style={{marginBottom: "20px"}}>{header}
                  </h3>
	                <ServicePackagesTab
                        mediumImageLink={this.props.mediumImageLink}
                        token={this.props.token}
                        project_slug={this.props.project_slug}
                        shoot_type_selected_id={this.state.shoot_type_selected_id}
                        service_packages={this.state.memoryPlusOrderedPackages}
						            length_of_packages={this.state.memoryPlusOrderedPackagesLength}
                        selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                        isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                        hours={this.state.memoryHours}
                        ticks={this.state.memoryTicks}
                        receiveType={this.props.receiveType}
                        servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                        link={this.props.link}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                        recommendationIndex={this.state.recommendationMemoryIndex}
                        shootTypeSelectedId={this.props.shootTypeSelectedId}
                        direct={this.props.direct}
                        step={this.props.step}
                        info={memoryPlusInfo}
                    />

	            </div>

	        );
	    }
	    else if (this.props.receiveType=="online-gallery"){
	        return(
	            <div id="packages" style={{margin: "5% 0 0 0"}}>
                            <div className="ball glowing col-xs-12 col-md-6 col-md-offset-3 btn-lower-prices">
                            <a id="lower_price" href="https://app.kadro.co/call_request">قیمت کمتر میخواهم</a></div>
	                <h3  style={{marginBottom: "20px"}} >{header}</h3>
	                <ServicePackagesTab
                        mediumImageLink={this.props.mediumImageLink}
                        token={this.props.token}
                        project_slug={this.props.project_slug}
                        shoot_type_selected_id={this.state.shoot_type_selected_id}
                        service_packages={this.state.privateGalleryOrderedPackages}
                        length_of_packages={this.state.privateGalleryOrderedPackagesLength}
                        isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                        selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                        receiveType={this.state.receiveType}
                        servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                        link={this.props.link}
                        hours={this.state.galleryHours}
                        ticks={this.state.galleryTicks}
                        wait={this.state.wait}
                        handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                        recommendationIndex={this.state.recommendationGalleryIndex}
                        shootTypeSelectedId={this.props.shootTypeSelectedId}
                        direct={this.props.direct}
                        step={this.props.step}
                        info={onlineGalleryInfo}
                    />


	            </div>

	        );
	    }
	    else{
	        return <div id='packages'></div>;
	    }
	}
}
