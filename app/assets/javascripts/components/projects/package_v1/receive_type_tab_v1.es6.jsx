class ReceiveTypeTabV1 extends React.Component {
	constructor(props) {
        super(props);
        this.state = {
            receiveType: 'online-gallery',
            shoot_type_selected_id:'',
            deliveryAtLocation:'',
            deliverySectionClicked: false,
            galleryHours:[],
            memoryHours:[],
            galleryTicks:[],
            memoryTicks:[],
            privateGalleryOrderedPackages:[],
            memoryPlusOrderedPackagesLength:0,
            memoryPlusOrderedPackages:[],
            privateGalleryOrderedPackagesLength:0,
            wait:false,
            recommendationGalleryIndex:0,
            recommendationMemoryIndex:0,
            directInfoReceived:false,
            shootTypeSelectedTitle:'',
            shootTypeSelectedExtendedHourCost:'70000',
        };
        this.handleClickMemoryPlus = this.handleClickMemoryPlus.bind(this);
        this.handleClickOnlineGallery = this.handleClickOnlineGallery.bind(this);
        //this.handleCallSubmitDeliveryAtLocationApi = this.handleCallSubmitDeliveryAtLocationApi.bind(this);
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
        this.setState({directInfoReceived:nextProps.directInfoReceived});
        this.setState({shootTypeSelectedTitle:nextProps.shootTypeSelectedTitle});
        this.setState({shootTypeSelectedExtendedHourCost:nextProps.shootTypeSelectedExtendedHourCost});
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
        }
        if(nextProps.shoot_type_selected_id!==this.props.shoot_type_selected_id)
        {

          this.setState({shoot_type_selected_id:nextProps.shoot_type_selected_id});
        }
        if(nextProps.receiveType !== this.props.receiveType)
          this.setState({'receiveType':nextProps.receiveType});

    }
    handleClickMemoryPlus(event){
    	if (this.props.galleryHours.length==0 || this.props.memoryHours.length==0 || this.props.galleryTicks.length==0 || this.props.memoryTicks.length==0 || this.props.memoryPlusOrderedPackagesLength==0 || this.props.privateGalleryOrderedPackagesLength==0)
    	{
    		return;
      }
      if(this.state.receiveType==='online-gallery')
      {
        this.setState({receiveType:'memory-plus'});
        this.setState({deliveryAtLocation:'true'},()=>{
          this.handleCallSubmitDeliveryAtLocationApi();
        });
      }
      else
      {
        this.setState({receiveType:'online-gallery'});
        this.setState({deliveryAtLocation:'false'},()=>{
          this.handleCallSubmitDeliveryAtLocationApi();
        });
      }
      

      var target = $('#price_selection');
      if( target.length ) {
        $('html, body').stop().animate({
            scrollTop: target.offset().top
        }, 1000);
      }

    }
    handleClickOnlineGallery(event){
    	if (this.props.galleryHours.length==0 || this.props.memoryHours.length==0 || this.props.galleryTicks.length==0 || this.props.memoryTicks.length==0 || this.props.memoryPlusOrderedPackagesLength==0 || this.props.privateGalleryOrderedPackagesLength==0)
    	{
    		return;
    	}
        this.setState({receiveType:'online-gallery'});
        this.setState({deliveryAtLocation:'false'},()=>{
        	this.handleCallSubmitDeliveryAtLocationApi();
        });

        var target = $('#price_selection');
        if( target.length ) {
          $('html, body').stop().animate({
              scrollTop: target.offset().top
          }, 1000);
        }
    }
    handleCallSubmitDeliveryAtLocationApi(){
    	if(!this.state.deliverySectionClicked){
    		gtag('event', 'page_view', {
			  'page_path': getPagePath(this.props.project_slug,7),
			  'method': 'Google'
			});
    		this.setState({deliverySectionClicked:true});
    	}
        let body="reserve[delivery_at_location]="+this.state.deliveryAtLocation+"&project_slug="+this.props.project_slug;
        let url=this.props.link+'/api/v1/submit_delivery_at_location';

    	//////////////get user's location/////////
    	//getUserLocation();
        //////////////////////////////////////////

        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .catch(function(e){console.log(e)});


    }
	render(){
    let headerNumber= (!this.props.direct && !this.props.locationWasSelected)?'۳-':((this.props.direct && !this.props.locationWasSelected)||(!this.props.direct && this.props.locationWasSelected))?'۲-':'۱-';
		
			return(
				<React.Fragment>
					<div className="pricing" id="receive-type">
              <h3>
              {headerNumber}
              تحویل آنی
              </h3>
              <div className="pricing-section text-center" id="delivery-section" style={{marginBottom: '2%'}}>

                  <a id="memory-plus" className={"block "+((this.state.receiveType==='memory-plus')? 'selected':'')} style={{border:"none"}} onClick={this.handleClickMemoryPlus}>
                       <div className="memory-plus-checkbox checkbox-control">
                          <input
                          type="checkbox"
                          id="memory-plus-check"
                          value="انتخاب توافق"
                          required=""
                          checked={this.state.receiveType==='memory-plus'}
                          onChange={this.handleClickMemoryPlus}
                          />
                          <div className="img-box hidden-xs">
                            <img src="/img/memory-plus.png" />
                          </div>
                          <div className="info-box receive_info_box">
                              <p className="title receive_title">
                               میخواهم عکسها را در محل تحویل بگیرم.
                              </p>
                              <p className="description" style={{textAlign: 'right'}}>
                                <strong>
                                <span className="fa fa-check"></span>
                                امکان حذف همه عکسها از حافظه دوربین عکاس.
                                </strong>
                              </p>
                              <p className="description" style={{textAlign: 'right'}}>
                                <strong>
                                <span className="fa fa-check"></span>
                                <strong style={{color:"rgb(49, 206, 46)"}}> آنلاین </strong>
                                هم می تونید دریافت کنید.
                                </strong>
                              </p>
                          </div>
                      </div>
                  </a>
              </div>
          </div>
					<div id='price_selection'>
						<figure id="sp4" className="pricing ">
							<div ref="service_packages" className="shoot-package">
								<PriceSelectionTabV1
                  mediumImageLink={this.props.mediumImageLink}
                  shoot_type_selected_id={this.state.shoot_type_selected_id}
                  token={this.props.token}
                  project_slug={this.props.project_slug}
                  selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                  isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                  galleryHours={this.state.galleryHours}
                  memoryHours={this.state.memoryHours}
                  galleryTicks={this.state.galleryTicks}
                  memoryTicks={this.state.memoryTicks}
                  receiveType={this.state.receiveType}
                  memoryPlusOrderedPackages={this.state.memoryPlusOrderedPackages}
                  privateGalleryOrderedPackages={this.state.privateGalleryOrderedPackages}
                  memoryPlusOrderedPackagesLength={this.state.memoryPlusOrderedPackagesLength}
                  privateGalleryOrderedPackagesLength={this.state.privateGalleryOrderedPackagesLength}
                  servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                  link={this.props.link}
                  wait={this.state.wait}
                  handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                  recommendationGalleryIndex={this.state.recommendationGalleryIndex}
                  recommendationMemoryIndex={this.state.recommendationMemoryIndex}
                  direct={this.props.direct}
                  step={this.props.step}
                  locationIsSelected={this.props.locationIsSelected}
                  locationWasSelected={this.props.locationWasSelected}
                  shootTypeSelectedTitle={this.state.shootTypeSelectedTitle}
                  shootTypeSelectedExtendedHourCost={this.state.shootTypeSelectedExtendedHourCost}
                  />
                  </div>
              </figure>
          	</div>
				</React.Fragment>
			);
	}
}
