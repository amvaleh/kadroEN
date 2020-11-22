class Address extends React.Component {
	constructor(props) {
		super(props);
		this.state = {
			infoCompleted:false,
			addressDetail:'',
			workingAddress:'',
			loadedData:false,
			searchResults:[],
			noSearchResult:false,
			lattitudeSelected:"",
			longitudeSelected:"",
			mapInitCount:0,
		};
		this.handleLivingAddressChange=this.handleLivingAddressChange.bind(this);
		this.searchMap=this.searchMap.bind(this);
		this.submitSearchMap=this.submitSearchMap.bind(this);
		this.handleWorkingAddressInputChange=this.handleWorkingAddressInputChange.bind(this);
		this.updateMapSettings=this.updateMapSettings.bind(this);
		this.mapSetup=this.mapSetup.bind(this);
		this.mapReset=this.mapReset.bind(this);
	}
	componentDidMount(){
	
		if(this.props.loadLocation && !this.state.loadedData)
		{
			this.setState({addressDetail:this.props.locationData.living_address});
			this.setState({workingAddress:this.props.locationData.living_input});
			$( "#working_address" ).val(this.props.locationData.living_input);
			$( "#living_address" ).val(this.props.locationData.living_address);
			this.setState({loadedData:true})
		}
	}
	componentWillReceiveProps(nextProps){

		if(nextProps.infoCompleted!==this.props.infoCompleted)
        {  
            this.setState({infoCompleted:nextProps.infoCompleted});
            var target = $('#address');
            
            if(nextProps.infoCompleted)
            {
            	target.css("display", "block");
            	scrollToId(target);

            	if(!this.props.loadLocation && this.state.mapInitCount==0)
				{
					neshanMapInitialize(35.806937,51.4281577);
					this.mapSetup(35.806937,51.4281577);
					this.setState({mapInitCount:1});
				}
				else if(this.props.loadLocation && !this.state.loadedData &&  this.state.mapInitCount==0)
				{
					neshanMapInitialize(this.props.locationData.working_lat,this.props.locationData.working_long);
					this.mapSetup(this.props.locationData.working_lat,this.props.locationData.working_long);
					this.setState({mapInitCount:1});
				}
            }
            else{
            	target.css("display", "none");
            }
        }
 	}
 	handleLivingAddressChange(event){
 		
		this.setState({addressDetail:event.target.value},()=>{
			this.props.livingAddressCallback(this.state.addressDetail);
		});
	  	//this.setState({isMapSelected:true});//submit button enabled
	}
	handleWorkingAddressInputChange(event){
		$( "#working_address" ).parsley().validate();
		this.setState({workingAddress:event.target.value});
		this.props.workingAddressCallback(event.target.value);
		this.setState({searchResults:[]});
		this.searchMap(event.target.value);
	}
 	mapSetup(lat,lng){
 		neshanMap.on('drag', ()=>{
			let newCenter = neshanMap.getCenter();
			neshanMap.removeLayer(neshanMarker);
			neshanMarker= L.marker(newCenter, {
	            icon: myIcon,
	            draggable: true
	        }).addTo(neshanMap);
			this.updateMapSettings(newCenter);
			neshanMarker.on('dragend', (event)=>{
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
		});
		if(neshanMarker)
		{
			neshanMap.removeLayer(neshanMarker);
		}
        neshanMarker= L.marker([lat,lng], {
            icon: myIcon,
            draggable: true
        }).addTo(neshanMap);


		neshanMarker.on('dragend', (event)=>{
			let lngLat = event.target._latlng;
			this.updateMapSettings(lngLat);
		});

		this.setState({lattitudeSelected:String(lat)});
		this.setState({longitudeSelected:String(lng)});
		this.props.workingLatCallback(lat);
		this.props.workingLngCallback(lng);
 	}
 	mapReset(newLngLat)
 	{
 		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(newLngLat, prevZoom);

		neshanMap.on('drag', ()=>{
			let newCenter = neshanMap.getCenter();
			neshanMap.removeLayer(neshanMarker);
			neshanMarker= L.marker(newCenter, {
	            icon: myIcon,
	            draggable: true
	        }).addTo(neshanMap);
			this.updateMapSettings(newCenter);
			neshanMarker.on('dragend', (event)=>{
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
		});
		if(neshanMarker)
		{
			neshanMap.removeLayer(neshanMarker);
		}
        neshanMarker= L.marker(newLngLat, {
            icon: myIcon,
            draggable: true
        }).addTo(neshanMap);


		neshanMarker.on('dragend', (event)=>{
			let lngLat = event.target._latlng;
			this.updateMapSettings(lngLat);
		});

		this.setState({lattitudeSelected:newLngLat[0]});
		this.setState({longitudeSelected:newLngLat[1]});
		this.props.workingLatCallback(parseFloat(newLngLat[0]));
		this.props.workingLngCallback(parseFloat(newLngLat[1]));
 	}
 	submitSearchMap(event){
 		let seperatedLocation=$(event.currentTarget).attr('data_location').split(',').reverse();
		this.setState({workingAddress:$(event.currentTarget).attr('name_location')});
		this.props.workingAddressCallback($(event.currentTarget).attr('name_location'));
		this.setState({searchResults:[]});
		this.mapReset(seperatedLocation);
 	}
	searchMap(query)
	{
		let defaultSortedProvincesList=['تهران','البرز','خراسان رضوی', 'فارس', 'اصفهان', 'آذربایجان شرقی','یزد',"گیلان",'خوزستان','قزوین','آذربایجان غربی','زنجان','هرمزگان'];
		let allowedTypes=["city","island","neighborhood","town","village","hamlet","district","trunk","primary","secondary","tertiary","residential","roundabout","residential_complex"];
		let searchResults=[];
		let queryLat= '35.689198';
		let queryLng= '51.388973';
		if(this.state.lattitudeSelected!=="")
		{
			queryLat=this.state.lattitudeSelected;
			queryLng=this.state.longitudeSelected;
		}
		$.ajax({
		 url: "https://api.neshan.org/v1/search?term="+query+"&lat="+queryLat+"&lng="+queryLng,
		 type: "GET",
		 beforeSend: function(xhr){xhr.setRequestHeader('Api-Key', 'service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X');},
		 success: (res)=> {
			 	if(res.items.length==0){
					this.setState({noSearchResult:true});
				}
				res.items.map((item) =>{
					this.setState({noSearchResult:false});
					let searchResultItem={};
					let province="";
					let city="";
					let provinceCompleteName="";
					let category = "";
					switch(item.category) {
					  case 'place':
					    category="مکان";
					    break;
					  case 'municipal':
					    category="خیابان";
					    break;
					  case 'region':
					  	category="شهر یا روستا";
					  	break;
					}
					if(item.region.includes("،"))
	            	{
	            		let regionArray=item.region.split("،");

	            		city=regionArray[regionArray.length-2];
	            		provinceCompleteName=regionArray[regionArray.length-1];
	            		province = provinceCompleteName.replace('استان ','');
	            		if(province[0]==" ")
	            			province = province.slice(1);
	            	}
	            	else{
	            		provinceCompleteName=item.region;
	            		province = item.region.replace('استان ','');
	            		if(province[0]==" ")
	            			province = province.slice(1);
	            	}
		            if(defaultSortedProvincesList.includes(province) && allowedTypes.includes(item.type))
		            {
		            	searchResultItem.type1=item.type;
		            	searchResultItem.type=category;
		            	searchResultItem.location=item.location;
		            	searchResultItem.city=city;
		            	searchResultItem.province1=province;
		            	searchResultItem.province=provinceCompleteName;
		            	searchResultItem.name=item.title;
		            	searchResultItem.localities=item.neighbourhood;
		            	searchResults.push(searchResultItem);

		            }

		         });
				//////sorting the results////////////
				let typeOrderingIndexes=[];
				let defaultProvinceOrderingIndexes=[];

        		for (var i=0; i<defaultSortedProvincesList.length; i++)
					defaultProvinceOrderingIndexes[defaultSortedProvincesList[i]] = i;

        		for (var i=0; i<allowedTypes.length; i++)
					typeOrderingIndexes[allowedTypes[i]] = i;

				searchResults.sort( function(a, b) {
					if(typeOrderingIndexes[a.type1]!==typeOrderingIndexes[b.type1])
						return (typeOrderingIndexes[a.type1] - typeOrderingIndexes[b.type1]);
					else
						return (defaultProvinceOrderingIndexes[a.province1] - defaultProvinceOrderingIndexes[b.province1]);
				});
				this.setState({searchResults:searchResults});
			 }
      });
	}

	updateMapSettings(newLngLat){
		let newLocation = [String(newLngLat.lat),String(newLngLat.lng)];
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(newLocation, prevZoom);

		this.setState({lattitudeSelected:String(newLngLat.lat)});
		this.setState({longitudeSelected:String(newLngLat.lng)});
		this.props.workingLatCallback(newLngLat.lat);
		this.props.workingLngCallback(newLngLat.lng);


	}
	render () {
		let searchResults = <React.Fragment></React.Fragment>;
		if(this.state.searchResults.length>0)
		{
			let searchItems = this.state.searchResults.map((item,i)=>{
				
				let location = [item.location.x,item.location.y];
				return(
					<li className="item-suggest" data_location={String(location)} name_location={item.name} onClick={this.submitSearchMap} key={i}>
						<p className="sg-title">
							{item.name}
							<span >{' ('+item.type+') '}</span>

						</p>
						<span className="sg-locality gray ellipsis">
								<span>{item.province}</span>

								{(item.city) &&
									<span>{item.city}</span>
								 }
								{ (item.localities)  && (item.localities.length > 0) &&
									<React.Fragment>
										<span>
										{' ('}
										</span>
										<span>
										{item.localities}
										</span>
										<span>
										{')'}
										</span>
									</React.Fragment>
								 }

						</span>
					</li>
					);
			});
			searchResults = <ul className="suggestion">
				{searchItems}
			</ul>;
		}
		else if(this.state.noSearchResult){
			searchResults = <p>نتیجه ای یافت نشد.</p>;
		}

		return (
			<div id="address" style={{display: 'none'}}>
				<div className="row" style={{marginTop: '3%'}}>
					
					<div className="col-sm-6">
						<input type="text" id="latt" name="latitude" style={{display:'none'}} value=''/>
			            <input type="text" id="long" name="longitude" style={{display:'none'}} value=''/>
						<label htmlFor="work_map">
						<span style={{color:'red'}}>*</span> محل کار شما:
						</label>
						<input  
						type="text" 
						className="form-control" 
						id="working_address" 
						placeholder="نام منطقه را وارد کنید" 
						required 
						onChange={this.handleWorkingAddressInputChange}
						value={this.state.workingAddress}
						 />
						{searchResults}
						<br />

						<div id="work_map" style={{width: '100%', height: '400px', position: 'relative', overflow: 'hidden'}}></div>

						<br />

					</div>
					<div className="col-sm-6">

						<label htmlFor="living_address"><span style={{color:'red'}}>*</span> آدرس محل زندگی شما:</label>
						<textarea 
						className="form-control" 
						type="text" 
						id="living_address" 
						required
						onChange={this.handleLivingAddressChange}
						value={this.state.addressDetail}
						data-parsley-trigger="keyup" 
						placeholder="لطفا آدرس دقیق پستی محل زندگی تان را بنویسید:" 
						
						  ></textarea>

					</div>
					
				</div>
						
			</div>
				
			);

		
	}
}