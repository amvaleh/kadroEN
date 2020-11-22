class Equipments extends React.Component {
	constructor() {
		super();
		this.state = {
			cameraEquipments:[],
			lenzEquipments:[],
			kitEquipments:[],
			checkedCameras:[],
			checkedEquipments:[],
			checkedKits:[],
			checkedKitEquipments:[],
			continueEnabled:true,
			cameraValuesSelected:[],
			lenzValuesSelected:[],
			loadedData: false,
		};
		this.handleSubmitButton=this.handleSubmitButton.bind(this);
		this.callEquipmentsApi=this.callEquipmentsApi.bind(this);
		this.handleClickKitBlock=this.handleClickKitBlock.bind(this);
		this.handleInformationValidation=this.handleInformationValidation.bind(this);
		this.checkKitsChecked=this.checkKitsChecked.bind(this);
	}
	componentDidMount(){
		if(this.props.loadData){
			for (var i = 0; i <this.props.signedData.photographer_kits.length; i++) {
				checkedKits[this.props.signedData.photographer_kits[i].id]=true;
			}
			this.setState({checkedKits:checkedKits});
			let cameraValuesSelected=[];
			for (var i = 0; i < this.props.signedData.photographer_cameras.length; i++) {
				cameraValuesSelected.push(this.props.signedData.photographer_cameras[i].id.toString());
			}

			let lenzValuesSelected=[];
			for (var i = 0; i < this.props.signedData.photographer_lenzs.length; i++) {
				lenzValuesSelected.push(this.props.signedData.photographer_lenzs[i].id.toString());
			}
			this.setState({cameraValuesSelected:cameraValuesSelected});
			this.setState({lenzValuesSelected:lenzValuesSelected});
			$('.cameras').dropdown('set selected',cameraValuesSelected);
			$('.lenzes').dropdown('set selected', lenzValuesSelected);
		}
		const step = getParameterByName('step');
		if(!step)
		{
			$( ".cameras" ).dropdown({
				onAdd: (values,text)=> {
					let newValues = values.split(',');
					let isDuplicate=true;
					newValues.forEach(value => {
						if(!this.state.cameraValuesSelected.includes(value))
						{
							isDuplicate=false;
						}
					});
					if(!isDuplicate)
					{
						this.setState({cameraValuesSelected:values.split(',')});
					}
						
					$( "input[name=camera]" ).parsley().validate();
				},
				onRemove:(removedValue,removedText)=> {
					let isFound=false;
					this.state.cameraValuesSelected.forEach((value,i) => {
						if(this.state.cameraValuesSelected[i]==removedValue)
						{
							let newArray=this.state.cameraValuesSelected;
							newArray.splice(i,1);
							this.setState({cameraValuesSelected:newArray});
							isFound=true;
						}
					});
					$( "input[name=camera]" ).parsley().validate();
				}
			});
			$( ".lenzes" ).dropdown({
				onAdd: (values,text)=> {
					let newValues = values.split(',');
					let isDuplicate=true;
					newValues.forEach(value => {
						if(!this.state.lenzValuesSelected.includes(value))
						{
							isDuplicate=false;
						}
					});
					if(!isDuplicate)
					{
						this.setState({lenzValuesSelected:values.split(',')});
					}
						
					$( "input[name=lenz]" ).parsley().validate();
				},
				onRemove:(removedValue,removedText)=> {
					let isFound=false;
					this.state.lenzValuesSelected.forEach((value,i) => {
						if(this.state.lenzValuesSelected[i]==removedValue)
						{
							let newArray=this.state.lenzValuesSelected;
							newArray.splice(i,1);
							this.setState({lenzValuesSelected:newArray});
							isFound=true;
						}
					});
					$( "input[name=lenz]" ).parsley().validate();
				}
			});	

			$('.cameras').dropdown('clear'); 
			$('.lenzes').dropdown('clear');
		}
		   
	}
	componentDidUpdate(prevProps,prevState){
		if(this.state.cameraValuesSelected.length>0 && this.state.lenzValuesSelected.length>0)
		{
			$('.cameras').dropdown('set selected',this.state.cameraValuesSelected);
			$('.lenzes').dropdown('set selected', this.state.lenzValuesSelected);
			
		}
		if(this.props.directToStep && prevProps.directToStep!==this.props.directToStep && this.props.directStep==1)
		{
			$('html, body').animate({scrollTop:0}, 'slow');
		}
		
	}
	checkKitsChecked()
	{

		for (var i = 0; i <this.state.checkedKits.length ; i++) {
			if(this.state.checkedKits[i])
			{
				return true;
			}
			
   	 	}
   	 	return false;
	}
	componentWillReceiveProps(nextProps){
		if(nextProps.lenzEquipments.length==0 || nextProps.cameraEquipments.length==0 || nextProps.kitEquipments.length==0)
		{
			
			this.setState({continueEnabled:false});
		}
		else{
			this.setState({continueEnabled:true});
			if(nextProps.lenzEquipments!==this.props.lenzEquipments || nextProps.cameraEquipments!==this.props.cameraEquipments || nextProps.photographerId!==this.props.photographerId)
	        {  
	        	
				
	            this.setState({lenzEquipments:nextProps.lenzEquipments});
	            this.setState({cameraEquipments:nextProps.cameraEquipments});
	            let kitChunkedEquipments=[];
	            let checkedKits=[];
	            if(this.checkKitsChecked())
				{
					
					for (var i = 0; i < nextProps.kitEquipments.length ; i++) {
						checkedKits[nextProps.kitEquipments[i].id]=this.state.checkedKits[nextProps.kitEquipments[i].id];
						
		       	 	}
					
				}
				else{
					
		            for (var i = 0; i < nextProps.kitEquipments.length ; i++) {
						checkedKits[i]=false;
						
		       	 	}
	       	 	}
	       	 	if(this.state.cameraValuesSelected.length>0)
	       	 	{
	       	 		$('.cameras').dropdown('set selected',this.state.cameraValuesSelected);
	       	 	}
	       	 	
				if(this.state.lenzValuesSelected.length>0)
				{
					$('.lenzes').dropdown('set selected', this.state.lenzValuesSelected);
				}
				
	            if(nextProps.loadData && !this.state.loadedData){
					if(!nextProps.directToStep)
						$('html, body').animate({scrollTop:0}, 'slow');
            		for (var i = 0; i <nextProps.signedData.photographer_kits.length; i++) {
    					checkedKits[nextProps.signedData.photographer_kits[i].id]=true;
            		}
            		let cameraValuesSelected=[];
            		for (var i = 0; i < nextProps.signedData.photographer_cameras.length; i++) {
            			cameraValuesSelected.push(nextProps.signedData.photographer_cameras[i].id.toString());
            		}
            		this.setState({cameraValuesSelected:cameraValuesSelected});

            		let lenzValuesSelected=[];
            		for (var i = 0; i < nextProps.signedData.photographer_lenzs.length; i++) {
            			lenzValuesSelected.push(nextProps.signedData.photographer_lenzs[i].id.toString());
					}
					this.setState({lenzValuesSelected:lenzValuesSelected});
					this.setState({loadedData:true});

				}
				
				kitChunkedEquipments=chunkArrayBySize(nextProps.kitEquipments,2);
        		this.setState({kitEquipments:kitChunkedEquipments});
				this.setState({checkedKits:checkedKits});
				
				
			}
		}
		
		

		
	}
	handleClickKitBlock(event){
		let targetCheckBox=$("input[id="+(event.currentTarget.id)+"]");
		let checkedKits=this.state.checkedKits;
		if(checkedKits[event.currentTarget.id]==false)
		{
			checkedKits[event.currentTarget.id]=true;
		}
		else
		{
			checkedKits[event.currentTarget.id]=false;
		}
		this.setState({checkedKits:checkedKits});
		$( "input[name=kit-check-box]" ).each(function() { 
			if(this.checked){
				$("#checkBoxError").css('display', 'none'); 
			}
		});


	}
	handleInformationValidation(){
		let formIsValid=true;
		let checkBoxIsValid=false;
		$( "input[name=camera]" ).parsley().validate();
		$( "input[name=lenz]" ).parsley().validate();
		$( "input[name=kit-check-box]" ).each(function() { 
			if(this.checked){
				checkBoxIsValid=true;
			}
		});
		
		if(!$( "input[name=camera]" ).parsley().isValid() || !$( "input[name=lenz]" ).parsley().isValid() || !checkBoxIsValid)
		{		
            formIsValid = false;
        }
        if(!checkBoxIsValid ){
        	$("#checkBoxError").css('display', 'block'); 
        	$("#checkBoxError").text('باید یکی از موارد زیر را تیک بزنید' );
        }
        else{
        	
        	$("#checkBoxError").css('display', 'none'); 
        }
		
      	return formIsValid;
	}
	handleSubmitButton(){
		var target = $('#submitEquipmentError');
		if(this.handleInformationValidation())
		{
			target.css('display', 'none');
			this.callEquipmentsApi();
			if(this.props.loadData)
			{
				this.props.deactiveLoadDataCallBack(false);
			}
		}
		else{
        	target.css('display', 'block');
        	scrollToId(target);
		}
		
	}
	callEquipmentsApi(){
		let shootTypes=[];
		let kitValuesSelected=[];
		this.state.kitEquipments
			.map((object) => 
			{

				let rowItems=object.map((rowItem)=>
				{
					if($("input[id="+(rowItem.id)+"]").prop("checked") == true)
					{
						kitValuesSelected.push(rowItem.id);
					}

				});

				
				
			});
		let cameraValuesSelected=$( "input[name=camera]" ).val();
		let lenzValuesSelected=$( "input[name=lenz]" ).val();
		

		let cameraValuesSelectedArray=[];
		let cameraValuesSelectedSplitted = cameraValuesSelected.split(",");
		for (var i = 0; i < cameraValuesSelectedSplitted.length; i++) {
		    cameraValuesSelectedArray.push( parseInt(cameraValuesSelectedSplitted[i]));
		}

		let lenzValuesSelectedArray=[];
		let lenzValuesSelectedSplitted = lenzValuesSelected.split(",");
		for (var i = 0; i < lenzValuesSelectedSplitted.length; i++) {
		    lenzValuesSelectedArray.push( parseInt(lenzValuesSelectedSplitted[i]));
		}



		let data={			
			kit_id:kitValuesSelected,
			camera_id:cameraValuesSelectedArray,
			lenz_id:lenzValuesSelectedArray,
			photographer_id:this.props.photographerId
		}
		let body = JSON.stringify(data);
        let url=this.props.link+'/api/v1/equipments';
		return fetch(url, {method:'post',
		            body: body,
		            headers: { "Content-Type": "application/json","Accept":"application/json"  ,"Authorization":this.props.token}})
		.then((response)=>{
		if (parseInt(response.status) !== 200) {

    		response.json().then((object) =>{
    			//console.log("response errors:");
    			//console.log(object.errors);
        		//move up
        		$("html, body").animate({ scrollTop: 0 }, "slow");

			});
    	}
        else{
        	let shootTypes=[];
        	let data = {}
        	response.json().then((object) =>{
        		//console.log(object);
				object['shoot_types'].map((item) =>{                			
	            	shootTypes.push(item);
    			});
				data['shootTypesLength']=shootTypes.length;
				shootTypes.sort(function(a, b) {
					return a.order - b.order;
				});
				data['shootTypes']=shootTypes;
				//console.log("callEquipmentsApi:");
				//console.log(data);
				this.props.equipmentsComponentFieldValuesCallBack(data);	

				this.props.nextStep();
                //console.log(object.photographer.id);	
			});
            
        }
        	
        })
        .catch(function(e){console.log(e)});
		       
		
	}
	render () {
		let cameraItems;
		let lenzItems;
		let kitItems;
		let persianDigits = "۰۱۲۳۴۵۶۷۸۹";
        let persianMap = persianDigits.split("");
		if(this.state.cameraEquipments.length==0 )
		{
			cameraItems=<div className="item" style={{direction: 'ltr'}}>
			</div>
		}
		else{
			cameraItems=this.state.cameraEquipments
			.map((object , i) =>
	    	{

				return(
					<div key={i} data-value={object.id} data-text={(object.brand)+" "+(object.model)} className="item" style={{direction: 'ltr'}}>
						{(object.brand)+" "+(object.model)}
					</div>
				);
			});
		}
		if(this.state.lenzEquipments.length==0)
		{
			lenzItems=<div className="item" style={{direction: 'ltr'}}></div>
		}
		else{
			lenzItems=this.state.lenzEquipments
			.map((object,i) =>
	    	{

				return(
					<div key={i} data-value={object.id} data-text={(object.brand)+" "+(object.model)} className="item" style={{direction: 'ltr'}}>
						{(object.brand)+" "+(object.model)}
					</div>
				);
			});
		
		}
		if(this.state.kitEquipments.length==0)
		{
			kitItems=<React.Fragment></React.Fragment>;
		}
		else{
			
			kitItems=this.state.kitEquipments
			.map((object,i) => 
			{
				let rowItems=object.map((rowItem,j)=>
				{
					let kitSubItems=rowItem.photography_tools.map((item,k)=>
					{
						let index=i+1;
						if(item.count!==0)
						{
							return(	
									<React.Fragment>

										<a key={k} className="kit-item">{(index.toString().replace(/\d/g, function (m) {
						                                        return persianMap[parseInt(m)];
						                                    }))+') '+(item.count.toString().replace(/\d/g, function (m) {
						                                        return persianMap[parseInt(m)];
						                                    }))+' عدد '+(item.name)}</a>
										<br />
									
									</React.Fragment>
								);
						}
						else{
							return(	
									<React.Fragment>
										<a key={k} className="kit-item">{(index.toString().replace(/\d/g, function (m) {
						                                return persianMap[parseInt(m)];
						                            }))+') '+(item.name)}</a>
										<br />
									
									</React.Fragment>
								);
						}
					});
					return(
						
						
							<a key={j} className={"block "+(this.state.checkedKits[rowItem.id]?'selected':'')} onClick={this.handleClickKitBlock} id={rowItem.id} style={{marginLeft:'2%'}}>
								<div className="img-box hidden-xs">
									<div className="checkbox-control">
										<input type="checkbox" id={rowItem.id} checked={this.state.checkedKits[rowItem.id]} name="kit-check-box" />					
									</div>
								</div>
								<div className="info-box">
									<p className="title"  style={{textAlign: 'right'}}>{rowItem.persian_title}</p>			
									<p className="description" style={{textAlign: 'right'}}>{kitSubItems}</p>
								</div>
							</a>
							
						
					
					);
				});

				return(
					<div className="pricing" key={i}>
						<div className="pricing-section">
							{rowItems}
						</div>
					</div>

				);
				
			});
				
				
			
		}
		
		return (
			<React.Fragment>
				<section id="main">
					<div className="container">
						<div className="main">
							<div className="tracker">
								<div className="process-tabs-line w-hidden-tiny">
									<span className="step-line step-line-package active" style={{width: "33.3333%" ,right: "0%"}}></span>
									<span className="step-line step-line-datetime " style={{width: '33.3333%', right: '33.3333%'}}></span>
									<span className="step-line step-line-details" style={{width:'33.3333%',right: '66.6667%'}}></span>
								</div>
								<div className="process-tab-button tracker-circle selected" style={{right: '0%'}}>
									<div className="tracker-text">
									اطلاعات اولیه
									</div>
								</div>
								<div className="process-tab-button tracker-circle selected " style={{right: '33.3333%'}}>
									<div className="tracker-text">
									تجهیزات عکاسی
									</div>
								</div>
								<div className="process-tab-button tracker-circle" style={{right: '66.6667%'}}>
									<div className="tracker-text">
									نمونه کارها
									</div>
								</div>
								<div className="process-tab-button tracker-circle" style={{right: '100%'}}>
									<div className="tracker-text">
									تجربه کاری
									</div>
								</div>
							</div>
							<div className="wrapper">
								<div className="row" style={{marginBottom: '30px'}}>
									<div className="col-sm-12">
										<p className="text-center">
									      به ما بگویید تجهیزات عکاسی چه دارید.
									      <br />
									      این به ما کمک می کند بدانیم شما
									      از پس چه کارهایی بر می آیید.
									    </p>
									    <hr />
									    <div className="alert alert-danger" id="submitEquipmentError" style={{ display: "none"}}>
											<p id="errors">در هر قسمت ستاره دار حداقل یک مورد را وارد کنید</p>
										</div>
									</div>
									<div className="col-sm-6" style={{marginTop: '4%'}}>
										<div className="col-sm-12">
											<h4>
											<span style={{color:'red'}}>*</span> دوربین
											</h4>
											<div className="cameras ui fluid multiple search normal selection dropdown">
												<input type="hidden" name="camera" required/>
														<i className="dropdown icon"></i>
												<div className="default text">
												انتخاب ...
												</div>
												<div className="menu">
											
													
													{cameraItems}
														
													
												</div>
											</div>
										</div>
									</div>
									<div className="col-sm-6" style={{marginTop: '4%'}}>
										<div className="col-sm-12">
											<h4>
											<span style={{color:'red'}}>*</span> لنز
											</h4>
											<div className="lenzes ui fluid multiple search normal selection dropdown">
												<input type="hidden" name="lenz" required/>
													<i className="dropdown icon"></i>
												<div className="default text">
												انتخاب ...
												</div>
												<div className="menu">										
													
													{lenzItems}

												</div>
											</div>
										</div>
									</div>
								</div>
								<hr />
								<div className="row">
									<h3>
									<span style={{color:'red'}}>*</span> لوازم جانبی 
									</h3>
									<p id="checkBoxError" style={{ color: "red" ,textDecoration: 'none' , display: "none"}}>

									</p>
								
								 	{kitItems}

								</div>
							</div>
						</div>
					</div>
				</section>
				<footer id="footer">
					<div className="container">
						<div className="wrap">
						  <a className="btn btn-gray"  onClick={this.props.previousStep}> بازگشت </a>
						  <button type="submit" id="submit_page_form"  className="btn btn-blue" onClick={this.handleSubmitButton} disabled={!this.state.continueEnabled}>ذخیره و ادامه
						  </button>
						</div>
					</div>
				</footer>
		</React.Fragment>
		);
	}
}