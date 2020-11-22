class Main extends React.Component {
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
            whereFieldValues : {},
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
            whenWhereFieldValues:[],
            studioSelected:false,
            studioLat:props.hasStudio=='true'?props.studioLat:null,
            studioLng:props.hasStudio=='true'?props.studioLng:null,
            hasStudio:props.hasStudio=='true'?true:false,
        };
    	this.nextStep = this.nextStep.bind(this);
    	this.previousStep = this.previousStep.bind(this);
    }
    componentDidMount(){
    	if(this.state.fullName=='null')
    	{
    		this.setState({fullName:''});
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
		let headerHeight;
		if( mobileDisplay && this.state.step==2 && !this.state.showMap)
			headerHeight='90vh';
		else if(mobileDisplay && this.state.step==2 && this.state.showMap)
			headerHeight='125vh';
		else if(mobileDisplay && this.state.step==1 && this.state.shootTypeSelectedId=='')
			headerHeight='110vh';
		else if(mobileDisplay && this.state.step==3 && !this.state.dateSelected)
			headerHeight='110vh';
		else if(mobileDisplay && this.state.step==4)
			headerHeight='110vh';
		else if(mobileDisplay && this.state.step==5)
			headerHeight='150vh';
		else if(mobileDisplay)
			headerHeight = '160vh';
		return(
			<React.Fragment>
 				<div className="header" style={{height:headerHeight}}>
      				<div className="container">
        				<section id="main">
							<h1>{this.props.appointments}</h1>
							<div style={{display: (this.state.step==1)?'':'none', paddingBottom: (this.state.businessOrPersonalSelected)?'0px': paddingButtom }}>
								<Package
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
								photographerUid = {this.props.photographerUid}
								removeDirectPhotographer={this.state.removeDirectPhotographer}
								direct={direct}
								/>;
							</div>
							<div style={{display: (this.state.step==2)?'':'none'}}>
								<Where
								project_slug={this.state.project_slug}
								token={this.state.token}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								shootTypeSelectedId={this.state.shootTypeSelectedId}
								selectedServicePackageId={this.state.selectedServicePackageId}
								whereFieldValues={(id) => this.setState({whereFieldValues:id})}
								isMapChanged={(id) => this.setState({isMapChanged:id})}
								showMapCallBack={(id) => this.setState({showMap:id})}
								link={this.props.link}
								step={this.state.step}
								photographerUid = {this.props.photographerUid}
								whenWhereFieldValuesCallBack={(id) => this.setState({whenWhereFieldValues:id})}
								photographerDirectCityName={this.state.packageFieldValues['photographerDirectCityName']}
								photographerDirectName={this.state.packageFieldValues['photographerDirectName']}
								removeDirectPhotographer={this.state.removeDirectPhotographer}
								direct={direct}
								studioLat={this.state.studioLat}
								studioLng={this.state.studioLng}
								hasStudio={this.state.hasStudio}
								/>
							</div>
							<div style={{display: (this.state.step==3)?'':'none'}}>
								<When
								/*isTimeSelected={(id) => this.setState({isTimeSelected:id})}*/
								token={this.state.token}
								project_slug={this.state.project_slug}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								shootTypeSelectedId={this.state.shootTypeSelectedId}
								availablePhotographers={(id) => this.setState({availablePhotographers:id})}
								whenWhereFieldValues={this.state.whenWhereFieldValues}
								lattitudeSelected={this.state.whereFieldValues.addressLng}
								longitudeSelected={this.state.whereFieldValues.addressLat}
								addressInput={this.state.whereFieldValues.addressInput}
								addressDetail={this.state.whereFieldValues.addressDetail}
								selectedServicePackageId={this.state.selectedServicePackageId}
								whenFieldValues={(id) => this.setState({whenFieldValues:id})}
								dateSelectedCallBack={(id) => this.setState({dateSelected:id})}
								removeDirectPhotographerCallBack={(id)=> this.setState({removeDirectPhotographer:id})}
								studioSelected={this.state.whereFieldValues['studioSelected']}
								/*persianDateTimeData_callBack={(id) => this.setState({persianDateTimeData:id})}*/
								isMapChanged={this.state.isMapChanged}
								link={this.props.link}
								step={this.state.step}
								photographerUid = {this.props.photographerUid}
								direct={direct}
								/>
							</div>
							<div style={{display: (this.state.step==4)?'':'none'}}>
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
								photographerUid = {(this.state.removeDirectPhotographer)?null:this.props.photographerUid}
								direct={direct}
								/>
							</div>
							<div style={{display: (this.state.step==5)?'':'none'}}>
								<Details
								project_slug={this.state.project_slug}
								token={this.state.token}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								feedbacks={this.state.feedbacks}
								photographerSelectedId={this.state.photographersFieldValues['photographerSelectedId']}
								fullName={this.state.packageFieldValues['fullName']}
								mobileNumber={this.state.packageFieldValues['mobileNumber']}
								link={this.props.link}
			        			detailsFieldValues={(id)=> this.setState({detailsFieldValues:id})}
			        			photographersFieldValues={this.state.photographersFieldValues}
			        			fullNameCallBack={(id)=> this.setState({fullName:id})}
			        			mobileNumberCallBack={(id)=> this.setState({mobileNumber:id})}
			        			signed={this.state.signed}
			        			step={this.state.step}
								/>
							</div>
							<div style={{display: (this.state.step==6)?'':'none',paddingBottom: '255px'}}>
								<Receipt
								project_slug={this.state.project_slug}
								token={this.state.token}
								nextStep={this.nextStep}
								previousStep={this.previousStep}
								whereFieldValues={this.state.whereFieldValues}
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
