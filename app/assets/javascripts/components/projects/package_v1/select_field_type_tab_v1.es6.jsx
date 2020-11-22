 class SelectFieldTypeTabV1 extends React.Component {
    constructor(props) {
        super(props);
        this.state = {
            shoot_type_selected_id: '',
            wait:false,
        };
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
        if(nextProps.mapIsSubmitted!==this.props.mapIsSubmitted)
        {
            this.setState({mapIsSubmitted:nextProps.mapIsSubmitted});
        }
    }
    render(){
    	
        if(this.props.selectedType=="business" && !this.props.direct){

            return(
                
                	<ShootTypesTabV2
                    token={this.props.token} 
                    project_slug={this.props.project_slug} 
                    shoot_types={this.props.business_shoot_types}  
                    selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                    isServiceSelected_callBack1={this.props.isServiceSelected_callBack1} 
                    isServiceSelected_callBack2={this.props.isServiceSelected_callBack2}
                    isServiceSelected_callBack3={this.props.isServiceSelected_callBack3}
                    isMapShownCallBack={this.props.isMapShownCallBack}
                    mapIsSubmitted={this.state.mapIsSubmitted}
                    shoot_type_selected_title_callBack={this.props.shoot_type_selected_title_callBack}
                    shoot_type_selected_id_callBack1={this.props.shoot_type_selected_id_callBack1}
                    shoot_type_selected_id_callBack2={this.props.shoot_type_selected_id_callBack2}
                    shoot_type_selected_id={this.state.shoot_type_selected_id}
                    servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                    link={this.props.link}
                    wait={this.state.wait}
                    handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                    handleDirectSubmitButtonCallBack={this.props.handleDirectSubmitButtonCallBack}
                    direct={this.props.direct}
                    step={this.props.step}
                    locationWasSelected={this.props.locationWasSelected}
                    studioLat={this.props.studioLat}
                    studioLng={this.props.studioLng}
                    hasStudio={this.props.hasStudio}
                    whereFieldValuesCallBack={this.props.whereFieldValuesCallBack}
                    whereFieldValuesCallBack1={this.props.whereFieldValuesCallBack1}
                    removeDirectPhotographer={this.props.removeDirectPhotographer}
                    photographerUid={this.props.photographerUid}
                    isMapChangedCallBack={this.props.isMapChangedCallBack}
                    photographerUidCallBack={this.props.photographerUidCallBack}
                    photographerUidCallBack1={this.props.photographerUidCallBack1}
                    setShowStudiosCallBack={this.props.setShowStudiosCallBack}
                    />
                
            );
        }
        else if (this.props.selectedType=="personal" && !this.props.direct){
        	
            return(
                
                	<ShootTypesTabV2
                    token={this.props.token} 
                    project_slug={this.props.project_slug} 
                    shoot_types={this.props.personal_shoot_types} 
                    selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack} 
                    isServiceSelected_callBack1={this.props.isServiceSelected_callBack1} 
                    isServiceSelected_callBack2={this.props.isServiceSelected_callBack2} 
                    isServiceSelected_callBack3={this.props.isServiceSelected_callBack3}
                    isMapShownCallBack={this.props.isMapShownCallBack}
                    mapIsSubmitted={this.state.mapIsSubmitted}
                    shoot_type_selected_title_callBack={this.props.shoot_type_selected_title_callBack}
                    shoot_type_selected_id_callBack1={this.props.shoot_type_selected_id_callBack1}
                    shoot_type_selected_id_callBack2={this.props.shoot_type_selected_id_callBack2}
                    shoot_type_selected_id={this.state.shoot_type_selected_id}
                    servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                    link={this.props.link}
                    wait={this.state.wait}
                    handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                    handleDirectSubmitButtonCallBack={this.props.handleDirectSubmitButtonCallBack}
                    direct={this.props.direct}
                    step={this.props.step}
                    locationWasSelected={this.props.locationWasSelected}
                    studioLat={this.props.studioLat}
                    studioLng={this.props.studioLng}
                    hasStudio={this.props.hasStudio}
                    whereFieldValuesCallBack={this.props.whereFieldValuesCallBack}
                    whereFieldValuesCallBack1={this.props.whereFieldValuesCallBack1}
                    removeDirectPhotographer={this.props.removeDirectPhotographer}
                    photographerUid={this.props.photographerUid}
                    isMapChangedCallBack={this.props.isMapChangedCallBack}
                    photographerUidCallBack={this.props.photographerUidCallBack}
                    photographerUidCallBack1={this.props.photographerUidCallBack1}
                    setShowStudiosCallBack={this.props.setShowStudiosCallBack}
                    />
            	
            );
        }
        else if(this.props.direct && this.props.startDirect)
        {
             return(
                
                    <ShootTypesTabV2
                    token={this.props.token} 
                    project_slug={this.props.project_slug}
                    selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack} 
                    isServiceSelected_callBack1={this.props.isServiceSelected_callBack1} 
                    isServiceSelected_callBack2={this.props.isServiceSelected_callBack2} 
                    isServiceSelected_callBack3={this.props.isServiceSelected_callBack3}
                    isMapShownCallBack={this.props.isMapShownCallBack}
                    mapIsSubmitted={this.state.mapIsSubmitted}
                    shoot_type_selected_title_callBack={this.props.shoot_type_selected_title_callBack}
                    shoot_type_selected_id_callBack1={this.props.shoot_type_selected_id_callBack1}
                    shoot_type_selected_id_callBack2={this.props.shoot_type_selected_id_callBack2}
                    shoot_type_selected_id={this.props.shoot_type_selected_id}
                    servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                    link={this.props.link}
                    wait={this.state.wait}
                    handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
                    handleDirectSubmitButtonCallBack={this.props.handleDirectSubmitButtonCallBack}
                    direct={this.props.direct}
                    step={this.props.step}
                    locationWasSelected={this.props.locationWasSelected}
                    studioLat={this.props.studioLat}
                    studioLng={this.props.studioLng}
                    hasStudio={this.props.hasStudio}
                    whereFieldValuesCallBack={this.props.whereFieldValuesCallBack}
                    whereFieldValuesCallBack1={this.props.whereFieldValuesCallBack1}
                    removeDirectPhotographer={this.props.removeDirectPhotographer}
                    photographerUid={this.props.photographerUid}
                    isMapChangedCallBack={this.props.isMapChangedCallBack}
                    photographerUidCallBack={this.props.photographerUidCallBack}
                    photographerUidCallBack1={this.props.photographerUidCallBack1}
                    directShootTypeSelectedTitle={this.props.directShootTypeSelectedTitle}
                    directShootTypeSelectedExtendedCost={this.props.directShootTypeSelectedExtendedCost}
                    setShowStudiosCallBack={this.props.setShowStudiosCallBack}
                    />
                
            );
        }
        else{
            return(

                <div id="detail">
                </div>
            );
        }
    }
}
