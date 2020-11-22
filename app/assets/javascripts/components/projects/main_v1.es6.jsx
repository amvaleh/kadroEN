class MainV1 extends React.Component {
	constructor(props) {
        super(props);
        let direct = this.props.shootTypeSelectedId!==null;
        this.state = {
            step: 1 ,
            token: '',
            project_slug: '',
            selectedServicePackageId: '',
            shootTypeSelectedId:!direct?'':props.shootTypeSelectedId,
            shootTypeSelectedTitle:!direct?'':props.shootTypeSelectedTitle,
            availablePhotographers:[],
            photographerSelectedId:!direct?'':props.photographerSelectedId,
            feedbacks:[],
            subtotal:-1,
            addressLng:'',
            addressLat:'',
            addressInput:'',
            addressDetail:'',
            packageFieldValues : {},
            whenFieldValues: {},
            photographersFieldValues:{},
            detailsFieldValues:{},
            TransportationCost: '',
            isMapChanged:false,
            businessOrPersonalSelected:false,
            mobileNumber:props.mobile_number,
            fullName:props.full_name,
            signed:props.signed,
            showMap:false,
            dateSelected:false,
            removeDirectPhotographer:false,
            studioSelected:false,
            locationWasSelected:false,
            studioLat:props.hasStudio=='true'?props.studioLat:null,
            studioLng:props.hasStudio=='true'?props.studioLng:null,
            hasStudio:props.hasStudio=='true'?true:false,
            photographerUid:props.photographerUid,
			projectId:-1,
			studiosFilterSelected:false,
        };
    	this.nextStep = this.nextStep.bind(this);
    	this.previousStep = this.previousStep.bind(this);
    }
    componentDidMount(){
    	if(this.state.fullName=='null')
    	{
    		this.setState({fullName:''});
    	}
    	///remove photographer uid from url
	    let url = window.location.href;
	    if(url.indexOf("shoot_location")!==-1)
	    {
	    	this.setState({locationWasSelected:true});
		}
		
    }
    nextStep() {
	  this.setState({
	    step : this.state.step + 1
	  },()=>{
	  	gtag('event', 'page_view', {
		  'page_path': getPagePath(this.state.project_slug,this.state.step),
		  'method': 'Google'
		});
	  });
	  $("html, body").animate({ scrollTop: 0 }, "slow");
	}

// Same as nextStep, but decrementing
	previousStep() {
		if(this.state.step!=1)
		{

		  this.setState({
		    step : this.state.step - 1
		  },()=>{
		  	gtag('event', 'page_view', {
			  'page_path': getPagePath(this.state.project_slug,this.state.step),
			  'method': 'Google'
			});

		  	if(this.state.step==1){
		  		let target = $('#packages');
	          	if( target.length ) {
		          $('html, body').stop().animate({
		              scrollTop: target.offset().top
		          }, 1000);
		        }
		  	}
		  	else{
		  		$("html, body").animate({ scrollTop: 0 }, "slow");
		  	}
		  });
		}
		else{
			return;
		}


	}/*215vh*/
	render () {
		let paddingButtom;
		if(mobileDisplay)
			paddingButtom='140px';
		else
			paddingButtom='390px';

		let direct = this.props.shootTypeSelectedId!==null && this.props.shootTypeSelectedId.length>0;
		let headerHeight= '',headerPaddingButtom="";
		/*if( mobileDisplay && this.state.step==2 && !this.state.showMap)
			headerHeight='90vh';
		else if(mobileDisplay && this.state.step==2 && this.state.showMap)
			headerHeight='125vh';*/
		if(mobileDisplay && this.state.step==1 && this.state.shootTypeSelectedId=='')
			headerHeight='110vh';
		else if(mobileDisplay && this.state.step==2 && !this.state.dateSelected)
			headerHeight='110vh';
		else if(this.state.step==3)
		{

			headerPaddingButtom='0px';
			if(mobileDisplay)
			{
				headerHeight='111vh';
			}
		}	
		else if(mobileDisplay && this.state.step==4)
			headerHeight='120vh';
		else if(mobileDisplay)
			headerHeight = '160vh';
		return(
			<React.Fragment>
 				<div className="header" style={{height:headerHeight,paddingButtom:headerPaddingButtom}}>
      				<div className="container">
        				<section id="main">
							<h1>{this.props.appointments}</h1>
							<div style={{display: (this.state.step==1)?'':'none', paddingBottom: (this.state.businessOrPersonalSelected)?'0px': paddingButtom }}>
								<PackageV1
								selectedServicePackageIdCallBack={(id) => this.setState({selectedServicePackageId:id})}
								shoot_type_selected_id_callBack1={(id) => this.setState({shootTypeSelectedId:id})}
								shoot_type_selected_title_callBack={(id) => this.setState({shootTypeSelectedTitle:id})}
								project_slug={(slug) => this.setState({project_slug:slug})}
								token={(t) => this.setState({token:t})}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								packageFieldValuesCallBack={(id) => this.setState({packageFieldValues:id})}
								businessOrPersonalSelectedCallBack={(id) => this.setState({businessOrPersonalSelected:id})}
								fullName={this.state.fullName}
								mobileNumber={this.state.mobileNumber}
								signed={this.state.signed}
								link={this.props.link}
								step={this.state.step}
								shootTypeSelectedId={this.props.shootTypeSelectedId}
								photographerUid = {this.state.photographerUid}
								removeDirectPhotographer={this.state.removeDirectPhotographer}
								locationWasSelected={this.state.locationWasSelected}
								direct={direct}
								studioLat={this.state.studioLat}
								studioLng={this.state.studioLng}
								hasStudio={this.state.hasStudio}
								isMapChangedCallBack={(id) => this.setState({isMapChanged:id})}
								photographerUidCallBack={(id)=>this.setState({photographerUid:id})}
								photographerUidCallBack2={(id)=>this.setState({photographerUid:id})}
								projectIdInitCallBack={(id)=>this.setState({projectId:id})}
								setShowStudiosCallBack={(id)=>this.setState({studiosFilterSelected:id})}
								/>;
							</div>
								
							<div style={{display: (this.state.step==2)?'':'none'}}>
								<When
								/*isTimeSelected={(id) => this.setState({isTimeSelected:id})}*/
								token={this.state.token}
								project_slug={this.state.project_slug}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								shootTypeSelectedId={this.state.shootTypeSelectedId}
								availablePhotographers={(id) => this.setState({availablePhotographers:id})}
								whenWhereFieldValues={this.state.packageFieldValues}
								lattitudeSelected={this.state.packageFieldValues.addressLng}
								longitudeSelected={this.state.packageFieldValues.addressLat}
								addressInput={this.state.packageFieldValues.addressInput}
								addressDetail={this.state.packageFieldValues.addressDetail}
								selectedServicePackageId={this.state.selectedServicePackageId}
								whenFieldValues={(id) => this.setState({whenFieldValues:id})}
								dateSelectedCallBack={(id) => this.setState({dateSelected:id})}
								removeDirectPhotographerCallBack={(id)=> this.setState({removeDirectPhotographer:id})}
								studioSelected={this.state.packageFieldValues['studioSelected']}
								/*persianDateTimeData_callBack={(id) => this.setState({persianDateTimeData:id})}*/
								isMapChanged={this.state.isMapChanged}
								link={this.props.link}
								step={this.state.step}
								photographerUid = {this.state.photographerUid}
								direct={direct}
								studiosFilterSelected={this.state.studiosFilterSelected}
								/>
							</div>
							<div style={{display: (this.state.step==3)?'':'none'}}>
								<Photographers
								project_slug={this.state.project_slug}
								token={this.state.token}
								availablePhotographers={this.state.availablePhotographers}
								isMapChanged={this.state.isMapChanged}
								shootTypeSelectedId={this.state.shootTypeSelectedId}
								selectedServicePackageId={this.state.selectedServicePackageId}
								shootTypeSelectedTitle={this.state.shootTypeSelectedTitle}
								previousStep={this.previousStep}
								nextStep={this.nextStep}
								feedbacks={(id) => this.setState({feedbacks:id})}
								dateTimeSelected={this.state.whenFieldValues['dateTimeSelected']}
								photographersFieldValues={(id) => this.setState({photographersFieldValues:id})}
								link={this.props.link}
								step={this.state.step}
								photographerUid = {(this.state.removeDirectPhotographer)?null:this.state.photographerUid}
								direct={direct}
								studiosFilterSelected={this.state.studiosFilterSelected}
								/>
							</div>
							<div style={{display: (this.state.step==4)?'':'none'}}>
								<Details
								project_slug={this.state.project_slug}
								token={this.state.token}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								feedbacks={this.state.feedbacks}
								photographerSelectedId={this.state.photographersFieldValues['photographerSelectedId']}
								fullName={this.state.fullName}
								mobileNumber={this.state.mobileNumber}
								link={this.props.link}
			        			detailsFieldValues={(id)=> this.setState({detailsFieldValues:id})}
			        			photographersFieldValues={this.state.photographersFieldValues}
			        			fullNameCallBack={(id)=> this.setState({fullName:id})}
			        			mobileNumberCallBack={(id)=> this.setState({mobileNumber:id})}
			        			signed={this.state.signed}
			        			step={this.state.step}
								/>
							</div>
							<div style={{display: (this.state.step==5)?'':'none',paddingBottom: '15px'}}>
								<Receipt
								project_slug={this.state.project_slug}
								projectId={this.state.projectId}
								token={this.state.token}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								whereFieldValues={this.state.packageFieldValues}
								whenFieldValues={this.state.whenFieldValues}
								packageFieldValues={this.state.packageFieldValues}
								photographersFieldValues={this.state.photographersFieldValues}
								detailsFieldValues={this.state.detailsFieldValues}
								link={this.props.link}
								signed={this.state.signed}
								/>
							</div>
						</section>
	      			</div>
	    		</div>
			</React.Fragment>
		);


	}
}