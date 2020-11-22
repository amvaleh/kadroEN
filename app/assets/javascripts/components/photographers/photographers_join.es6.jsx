class PhotographersJoin extends React.Component {
	constructor(props) {
        super();
        this.state = {
        	step: 1 ,
            infoFieldValues:{},
            socialInfosFieldValues:{},
            equipmentsFieldValues:{},
            lenzEquipments:[],
            cameraEquipments:[],
            kitEquipments:[],
            loadEquipment:false,
            loadLocation:false,
            loadInfo:false,
            loadPortfolio:false,
			loadExperience:false,
			loadExperienceData:false,
			directToStep:false,
			directStep:1,
			joinStep:(props.join_step)?props.join_step:'',
			joinToStep:(props.join_step)?true:false,
		};
    	this.nextStep = this.nextStep.bind(this);
    	this.previousStep = this.previousStep.bind(this);
    	this.experienceStep = this.experienceStep.bind(this);
    	this.portfolioStep = this.portfolioStep.bind(this);
    	this.equipmentStep = this.equipmentStep.bind(this);
    	this.infoStep = this.infoStep.bind(this);
    	this.doneStep = this.doneStep.bind(this);
    }
    nextStep() {
		if(this.state.directToStep)
		{
			window.location.replace(this.props.link+'/photographers/'+this.state.photographerMobileNumber+'/studio?notice=success_save');
			return;
		}
	  this.setState({
	    step : this.state.step + 1
	  });
	  $("html, body").animate({ scrollTop: 0 }, "slow");
	}
	previousStep() {
		if(this.state.directToStep)
		{
			window.location.replace(this.props.link+'/photographers/'+this.state.photographerMobileNumber+'/studio');
			return;
		}
	  this.setState({
	    step : this.state.step - 1
	  });
	  $('html, body').animate({scrollTop:$(document).height()}, 'slow');
	}
	doneStep(){
		this.setState({
	    	step : 5
	  	});
	  	$('html, body').animate({scrollTop:$(document).height()}, 'slow');
	}
	experienceStep(){
		this.setState({
	    	step : 4
	  	});
	}
	portfolioStep(){
		this.setState({
	    	step : 3
	  	});
	}
	equipmentStep(){
		this.setState({
	    	step : 2
	  	});
	}
	infoStep(){
		this.setState({
	    	step : 1
	  	});
	  	$('html, body').animate({scrollTop:$(document).height()}, 'slow');
	}
	componentDidMount(){
		let photographerInfoData={};
		let equipmentsFieldValues={};
		let socialInfosFieldValues={};
		
		if(this.props.join_step>1){//if Info and Location are complete
			//preparing for equipment (when join step is 2 it means that step 2 has finished)
			photographerInfoData={
				token:this.props.photographer_info.photographer.token,
				photographerId:this.props.photographer_info.photographer.id,
				firstName:this.props.photographer_info.photographer.first_name,
				lastName:this.props.photographer_info.photographer.last_name,
				uid:this.props.photographer_info.photographer.uid
			}
			this.setState({infoFieldValues:photographerInfoData});
			this.setState({kitEquipments:this.props.photographer_info.kits});
			this.setState({cameraEquipments:this.props.photographer_info.cameras});
			this.setState({lenzEquipments:this.props.photographer_info.lenzs});
			
		}
		if(this.props.join_step>2){	//if Equipment is complete
			this.setState({loadEquipment:true});
			equipmentsFieldValues['shootTypes']=this.props.photographer_info.shoot_types;
			equipmentsFieldValues['shootTypesLength']=this.props.photographer_info.shoot_types.length;
			this.setState({equipmentsFieldValues:equipmentsFieldValues});
		}
		if (this.props.join_step>3) {//if Portfolio is complete			
			socialInfosFieldValues['uid']=this.props.photographer_info.photographer.uid;
			this.setState({socialInfosFieldValues:socialInfosFieldValues});

		}
		//get params from url
		
		const step = parseInt(getParameterByName('step'));
		if(step)
		{
			this.setState({directToStep:true});
			this.setState({directStep:step})
			const mobileNumber = window.location.pathname.split('.')[1];
			this.setState({photographerMobileNumber:mobileNumber})
			if (step==1) {
				this.equipmentStep();
			}
			else if (step==2) {
				this.portfolioStep();
			}
			else if (step==3) {
				this.experienceStep();
			}
		}
		else{

			if (this.props.join_step==1) {
				this.infoStep();
			}
			if (this.props.join_step==2) {
				this.equipmentStep();
			}
			if (this.props.join_step==3) {
				this.portfolioStep();
			}
			if (this.props.join_step==4) {
				this.experienceStep();
			}
			if (this.props.join_step==5) {
				this.doneStep();
			}
		}
		if(this.props.join_step>4 ||(this.props.join_step==4&&this.props.photographer_info.photographer_experience!==null))
		{
			this.setState({loadExperienceData:true});
		}
	}
	render () {
		return(
			<React.Fragment>
				
				<div style={{display: (this.state.step==1)?'':'none'}}>
					<JoinHeader 
						signedIn={(this.props.join_step>0)?true:false}
						title="عضو کادرو شو"
					/>
					<Info 
					infoComponentFieldValuesCallBack={(Id) => this.setState({infoFieldValues:Id})}
					lenzEquipmentCallBack={(Id) => this.setState({lenzEquipments:Id})}
					cameraEquipmentCallBack={(Id) => this.setState({cameraEquipments:Id})}
					kitEquipmentCallBack={(Id) => this.setState({kitEquipments:Id})}
					link={this.props.link}
					loadLocation={(this.props.join_step>1)?true:false}
					loadInfo={(this.props.join_step>0)?true:false}
					infoData={this.props.photographer_info.photographer}
					locationData={this.props.photographer_info.location}
					nextStep={this.nextStep}
					previousStep={this.previousStep}
					/>;
				</div>
				<div style={{display: (this.state.step==2)?'':'none'}}>
					<JoinHeader 
						signedIn={(this.props.join_step>0)?true:false}
						title="تجهیزات عکاسیت چیاست؟"
					/>
					<Equipments 
					photographerId={this.state.infoFieldValues['photographerId']}
					token={this.state.infoFieldValues['token']}
					lenzEquipments={this.state.lenzEquipments}
					cameraEquipments={this.state.cameraEquipments}
					kitEquipments={this.state.kitEquipments}
					loadData={this.state.loadEquipment}
					signedData={this.props.photographer_info}
					deactiveLoadDataCallBack={(Id) => this.setState({loadEquipment:Id})}
					equipmentsComponentFieldValuesCallBack={(Id) => this.setState({equipmentsFieldValues:Id})}
					link={this.props.link}
					nextStep={this.nextStep}
					previousStep={this.previousStep}
					directToStep={this.state.directToStep}
					directStep={this.state.directStep}
					/>;
				</div>
				<div style={{display: (this.state.step==3)?'':'none'}}>
					<JoinHeader 
						signedIn={(this.props.join_step>0)?true:false}
						title="نمونه کارهات رو ببینیم!"
					/>
					<SocialInfos 
					link={this.props.link}
					nextStep={this.nextStep}
					previousStep={this.previousStep}
					photographerId={this.state.infoFieldValues['photographerId']}
					token={this.state.infoFieldValues['token']}
					shootTypes={this.state.equipmentsFieldValues['shootTypes']}
					shootTypesLength={this.state.equipmentsFieldValues['shootTypesLength']}
					socialInfosComponentFieldValuesCallBack={(Id) => this.setState({socialInfosFieldValues:Id})}
					loadData={(this.props.join_step>3)?true:false}
					loadUnCompletedData={(this.props.join_step>2)?true:false}
					signedData={this.props.photographer_info}
					directToStep={this.state.directToStep}
					directStep={this.state.directStep}
					/>;
				</div>
				<div style={{display: (this.state.step==4)?'':'none'}}>
					<JoinHeader 
						signedIn={(this.props.join_step>0)?true:false}
						title="چقدر تجربه کاری داری؟"
					/>
					<Experiences 
					link={this.props.link}
					nextStep={this.nextStep}
					previousStep={this.previousStep}
					photographerId={this.state.infoFieldValues['photographerId']}
					token={this.state.infoFieldValues['token']}
					loadData={(this.state.loadExperienceData)?true:false}
					signedData={this.props.photographer_info}
					directToStep={this.state.directToStep}
					directStep={this.state.directStep}
					/>;
				</div>
				<div style={{display: (this.state.step==5)?'':'none'}}>
					<JoinHeader 
						signedIn={(this.props.join_step>0)?true:false}
						title="اطلاعات شما دریافت شد."
					/>
					<Done 
					link={this.props.link}
					nextStep={this.nextStep}
					previousStep={this.previousStep}
					experienceStep={this.experienceStep}
					portfolioStep={this.portfolioStep}
					equipmentStep={this.equipmentStep}
					infoStep={this.infoStep}
					firstName={this.state.infoFieldValues['firstName']}
					lastName={this.state.infoFieldValues['lastName']}
					uid={this.state.socialInfosFieldValues['uid']}
					photographerId={this.state.infoFieldValues['photographerId']}
					token={this.state.infoFieldValues['token']}				
					/>;
				</div>
			</React.Fragment>
		);
	}
}