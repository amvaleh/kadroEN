class Where extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			addressDetail:'',
			dateTimeSelected:'',
			error_messages:{},
			lattitudeSelected:'',
			longitudeSelected:'',
			addressInput:'',
			isMapSelected:false,
			isMapChanged:false,
			showAddressDetail:false,
			wait:false,
			searchMapInputValue:'',
			searchResults:[],
			noSearchResult:false,
			showMap:false,
			mapInitCount:0,
			userLocationAsked:false,
			userLocationProvince:"",
			userLocation:null,
			sampleCities:[],
			moreCitySelectedId: -1,
			useStudio:false,
			checkStudioSelected:false,
			addressDetailsPopupShow:false,
			hasStudio:props.hasStudio,
		};
		this.handleSubmitButton=this.handleSubmitButton.bind(this);
		this.handleAddressDetailChange=this.handleAddressDetailChange.bind(this);
		this.callSubmitAddressApi=this.callSubmitAddressApi.bind(this);
		this.handleSearchMapInputChange=this.handleSearchMapInputChange.bind(this);
		this.handleMapExampleClick=this.handleMapExampleClick.bind(this);
		this.searchMap=this.searchMap.bind(this);
		this.submitSearchMap=this.submitSearchMap.bind(this);
		this.getUserLocation=this.getUserLocation.bind(this);
		this.getProvinceFromUserLocation=this.getProvinceFromUserLocation.bind(this);
		this.updateMapSettings=this.updateMapSettings.bind(this);
		this.getSampleCities=this.getSampleCities.bind(this);
		this.handleSelectOptionsChange=this.handleSelectOptionsChange.bind(this);
		this.goToCity=this.goToCity.bind(this);
		this.handleCheckStudioSelectedChange=this.handleCheckStudioSelectedChange.bind(this);
		this.addressDetailPopupSubmitButtonClicked=this.addressDetailPopupSubmitButtonClicked.bind(this);
		this.footerPosition='';
		this.footerWidth='';
		this.footerBottom='';
		this.footerLeft='';
		this.footerPadding='';
		this.mainHeight='';
		this.searchContainerClicked=false;
		this.searchContainerScrolling=false;
	}
	componentDidMount(){
		this.getSampleCities();
		$("#more_cities").prepend("<option value=''>بیشتر...</option>");
	}
	componentDidUpdate(){
		//disable any map changes while clicking or scrolling or dragging the search bar
		$('.suggestion').on('click', ()=>{
    		this.searchContainerClicked=true;
    	});
    	$('.suggestion').on('scroll', ()=>{
    		this.searchContainerScrolling=true;
    	});
    	$('.suggestion').on('drag', ()=>{
    		this.searchContainerDragging=true;
    	});
    	//

		if(this.props.step==2 && this.state.mapInitCount==0)
    	{
    		neshanMapInitialize(35.699739, 51.338097);
    		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
	    	let cityIsFinded=false;
    		if(directAndPhotographerSelected)
    		{
    			$('.region-example').each(( index,e )=>{
				  if($(e).attr('value')==this.props.photographerDirectCityName)
				  {
				  	$(e).addClass('selected');
				  	cityIsFinded=true
				  	this.goToCity($(e).attr('lat'),$(e).attr('lng'));
				  }
				});
				if(!cityIsFinded)
				{
				  	$('#more_cities').val(this.props.photographerDirectCityName);
				  	$('#more_cities').addClass('selected');
				  	this.goToCity($($("option:selected")[0]).attr('lat'),$($("option:selected")[0]).attr('lng'));
				}
    		}
    		else{
    			this.goToCity(35.699739,51.338097);
    		}

    		neshanMap.on('click', ()=>{
	    		if(this.searchContainerClicked)//if clicked on the search bar the map has also been clicked
				{
					this.searchContainerClicked=false;

				}
				else
					this.setState({searchResults:[]});
	    	});
    		neshanMap.on('drag', ()=>{
    			if(this.searchContainerScrolling)//if the search bar has been scrolled the map has also been dragged
    			{
    				this.searchContainerScrolling=false;
					let prevLngLat;
					if(this.state.lattitudeSelected)
						prevLngLat={lat:this.state.lattitudeSelected,lng:this.state.longitudeSelected};
					else
						prevLngLat={lat:35.699739,lng:51.338097};
   					this.updateMapSettings(prevLngLat)//unroll map dragged changes to the previous map state
    				return;
    			}
    			if (this.searchContainerDragging) {//if the search bar has been dragged the map has also been dragged
    				this.searchContainerDragging=false;
    				let prevLngLat;
					if(this.state.lattitudeSelected)
						prevLngLat={lat:this.state.lattitudeSelected,lng:this.state.longitudeSelected};
					else
						prevLngLat={lat:35.699739,lng:51.338097};
    				this.updateMapSettings(prevLngLat)//unroll map dragged changes to the previous map state
    				return;
    			}
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
			neshanMarker.on('dragend', (event)=>{
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
			this.setState({isMapSelected:true});//submit button enabled
		  	this.props.isMapChanged(true);
		  	this.setState({showAddressDetail:true});
    		this.setState({mapInitCount:1});

    	}
	}
	componentWillReceiveProps(nextProps){

		//////////////get user's location/////////
    	/*if(this.props.step==1 && nextProps.step==2 && !this.state.userLocationAsked)
    	{

    		this.setState({userLocationAsked:true});
    		this.getUserLocation();
    	}*/
        //////////////////////////////////////////
        if(nextProps.removeDirectPhotographer!==this.props.removeDirectPhotographer) //if studio is canceled reset location
        {
        	if(nextProps.removeDirectPhotographer)
        	{
        		this.setState({hasStudio:false});
        		if(this.state.checkStudioSelected)
        		{
	        		this.setState({checkStudioSelected:false});
	        		this.setState({searchMapInputValue: ''});
		    		if($($(".region-example.selected")[0]).attr('lat'))
		    		{
		    			this.goToCity($($(".region-example.selected")[0]).attr('lat'),$($(".region-example.selected")[0]).attr('lng'));
		    		}
		    		else if(this.goToCity($($("option:selected")[0]).attr('lat')))
		    		{
		    			this.goToCity($($("option:selected")[0]).attr('lat'),$($("option:selected")[0]).attr('lng'));
		    		}
		    		else
		    		{
		    			this.goToCity(35.699739,51.338097);
		    		}
		    		neshanMap.dragging.enable();
		    		neshanMarker.dragging.enable();
		    	}
        		
        	}
        }
	}
	getSampleCities(){
		let url=this.props.link+'/api/v2/active_cities';
        return fetch(url, {method:'get'})
            .then((response)=>{
            	response.json().then((object) =>{
					this.setState({sampleCities:object.cities});
				})


            })
            .catch(function(e){console.log(e)});
	}
    handleSelectOptionsChange(event){
    	$('.region-example').removeClass('selected');
    	if(event.target.value!=="")
			$('#more_cities').addClass('selected');
        this.goToCity($($("option:selected")[0]).attr('lat'),$($("option:selected")[0]).attr('lng'));
    }
	getUserLocation(){
	  if (navigator.geolocation)
	  {
	    navigator.geolocation.getCurrentPosition(this.getProvinceFromUserLocation,()=>{this.setState({userLocationProvince:""})});
	  }
	  else {
	    console.log("Geolocation is not supported by this browser.");
	  }
	}
	getProvinceFromUserLocation(position){
		let latlng = {lat:position.coords.latitude,lng: position.coords.longitude};
		this.setState({userLocation:latlng},()=>{
			this.updateMapSettings(this.state.userLocation);
		});
		let geocoder = new google.maps.Geocoder;
		geocoder.geocode({'location': latlng}, (results,status)=>{
			if(status==='OK')
			{
				let province = results[6].address_components[0].long_name.split(" ")[1];
				this.setState({userLocationProvince:province});
			}
		})
	}
	addressDetailPopupSubmitButtonClicked(){
		$("#modalNotes").modal("hide");
		this.setState({wait:true});
		this.setState({isMapSelected:false});
		this.callSubmitAddressApi();
		this.props.isMapChanged(false);
		var data = {
			addressLng: this.state.longitudeSelected,
			addressLat: this.state.lattitudeSelected,
			addressInput: this.state.searchMapInputValue,
			addressDetail: this.state.addressDetail,
	    }
		this.props.whereFieldValues(data);
    	this.props.nextStep();
	}
	handleSubmitButton(){

		/*$('#address-detail').parsley().validate();
		if(!$('#address-detail').parsley().isValid())
		{
			let target = $('#address-detail');
            if( target.length ) {
	          	$('html, body').stop().animate({
	              scrollTop: target.offset().top
	          	}, 1000);
	        }
			return;
		}*/
		if(!this.state.checkStudioSelected)
		{
			let target = $('#modalNotes');
            if( target.length ) {
	          	$('html, body').stop().animate({
	              scrollTop: target.offset().top
	          	}, 1000);
	        }
			$("#modalNotes").modal("show");
		}
		else
		{
			this.setState({wait:true});
			this.setState({isMapSelected:false});
			this.callSubmitAddressApi();
			this.props.isMapChanged(false);
			var data = {
				addressLng: this.state.longitudeSelected,
				addressLat: this.state.lattitudeSelected,
				addressInput: "",
				addressDetail: this.state.searchMapInputValue,
				studioSelected: this.state.checkStudioSelected,
		    }
			this.props.whereFieldValues(data);
	    	this.props.nextStep();
	    }
	}
	handleAddressDetailChange(event){
		this.setState({addressDetail: event.target.value})
	}
	handleMapExampleClick(event){
		$('.region-example').removeClass('selected');
		$(event.target).addClass('selected');
	  	this.goToCity($(event.target).attr('lat'),$(event.target).attr('lng'));
	}
	goToCity(lat,lng){
		let seperatedLocation=[lat,lng];
		this.setState({isMapSelected:true});//submit button enabled
	  	this.props.isMapChanged(true);
		this.setState({searchResults:[]});
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(seperatedLocation, prevZoom);

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
		if(neshanCircle && neshanMarker)
		{
			neshanMap.removeLayer(neshanCircle);
			neshanMap.removeLayer(neshanMarker);
		}
		neshanCircle=L.circle(seperatedLocation, 2000).addTo(neshanMap);
        neshanMarker= L.marker(seperatedLocation, {
            icon: myIcon,
            draggable: true
        }).addTo(neshanMap);


		neshanMarker.on('dragend', (event)=>{
			let lngLat = event.target._latlng;
			this.updateMapSettings(lngLat);
		});
		this.setState({lattitudeSelected:seperatedLocation[0]});
		this.setState({longitudeSelected:seperatedLocation[1]});
	  	this.setState({showAddressDetail:true});
	}
	searchMap(query){
		//let defaultSortedProvincesList=['تهران','البرز','خراسان رضوی', 'فارس', 'اصفهان', 'آذربایجان شرقی','یزد',"گیلان",'خوزستان','قزوین','آذربایجان غربی','زنجان','مازندران',,'همدان','کرمانشاه','کرمان','لرستان','گلستان','کردستان','مرکزی','اردبیل','قم','بوشهر','خراسان شمالی','خراسان جنوبی','سمنان','چهارمحال و بختیاری','کهگیلویه و بویراحمد','سیستان و بلوچستان','هرمزگان'];
		let allowedTypes=["city","island","neighborhood","town","village","hamlet","district","trunk","primary","secondary","tertiary","residential","roundabout","restaurant","cafe","park","fast_food","university","hotel","residential_complex","subway_station","amusement_park"];
		let searchResults=[];
		/*var geocoder = L.cedarmaps.geocoder('cedarmaps.streets');
		geocoder.query({query:query}, (err, res)=>{

			res.results.map((item) =>{
				let searchResultItem={};
	            if(defaultSortedProvincesList.includes(item.components.province))
	            {

	            	searchResultItem.type=item.type;
	            	searchResultItem.location=item.location.center;
	            	searchResultItem.city=item.components.city;
	            	searchResultItem.province=item.components.province;
	            	searchResultItem.name=item.name;
	            	searchResultItem.districts=item.components.districts;
	            	searchResultItem.localities=item.components.localities;
	            	searchResultItem.alt_name=item.alt_name;
	            	searchResults.push(searchResultItem);

	            }

	         });*/
	    //});
	    let queryLat= '35.689198';
		let queryLng= '51.388973';

		if(this.state.lattitudeSelected!=="")
		{
			queryLat=this.state.lattitudeSelected;
			queryLng=this.state.longitudeSelected;
		}
		else if(this.state.userLocation!==null)
		{
			queryLat=String(this.state.userLocation.lat);
			queryLng=String(this.state.userLocation.lng);
		}
	    $.ajax({
		 url: "https://api.neshan.org/v1/search?term="+query+"&lat="+queryLat+"&lng="+queryLng,
		 type: "GET",
		 beforeSend: function(xhr){xhr.setRequestHeader('Api-Key', 'service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X');},
		 success: (res)=> {
		 	if(res.items.length==0){
				this.setState({noSearchResult:true});
			}
			else{
				res.items.map((item) =>{
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
		            if(/*defaultSortedProvincesList.includes(province) && */allowedTypes.includes(item.type))
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
				/*let defaultProvinceOrderingIndexes=[];

        		for (var i=0; i<defaultSortedProvincesList.length; i++)
					defaultProvinceOrderingIndexes[defaultSortedProvincesList[i]] = i;
				*/
        		for (var i=0; i<allowedTypes.length; i++)
					typeOrderingIndexes[allowedTypes[i]] = i;

				/*if(this.state.userLocationProvince!="")
            	{
            		let userProvinceOrderingIndexes=[];
            		///put the province's order first
            		userProvinceOrderingIndexes[this.state.userLocationProvince]=0;

            		//find index of the user location province in provinces list
            		let userProvinceIndex=-1;
            		for (var i=0; i<defaultSortedProvincesList.length; i++)
            			if(this.state.userLocationProvince==defaultSortedProvincesList[i])
            				userProvinceIndex=i;

            		//remove user location province from provinces list
            		defaultSortedProvincesList.splice(userProvinceIndex,1);

					//put other provinces in order
					for (var i = 0; i < defaultSortedProvincesList.length; i++) {
						userProvinceOrderingIndexes[defaultSortedProvincesList[i]]=i+1;
					}

					searchResults.sort( function(a, b) {
						return (typeOrderingIndexes[a.type1] - typeOrderingIndexes[b.type1]);
					});
            		searchResults.sort( function(a, b) {
    					return (userProvinceOrderingIndexes[a.province1] - userProvinceOrderingIndexes[b.province1]);
    				});
				}
	            else
	            {*/
	            	//sort results by default order
	            	searchResults.sort( function(a, b) {
						return (typeOrderingIndexes[a.type1] - typeOrderingIndexes[b.type1]);
					});


	            /*	searchResults.sort( function(a, b) {
						return (defaultProvinceOrderingIndexes[a.province1] - defaultProvinceOrderingIndexes[b.province1]);
					});

				}*/
				///////////////////////////////////

				this.setState({searchResults:searchResults});
				this.setState({noSearchResult:false});
			}
		 }
      });


	}
	handleSearchMapInputChange(event){
		this.setState({searchMapInputValue: event.target.value});
		this.setState({searchResults:[]});
	  	if(event.target.value.length>0)
	  		this.searchMap(event.target.value);
	  	//this.setState({showMap:false});
	  	//this.props.showMapCallBack(false);
	}
	updateMapSettings(newLngLat){
		let newLocation = [String(newLngLat.lat),String(newLngLat.lng)];
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(newLocation, prevZoom);
		neshanMap.removeLayer(neshanCircle);

		neshanCircle=L.circle(newLocation, 2000).addTo(neshanMap);

		this.setState({lattitudeSelected:String(newLngLat.lat)});
		this.setState({longitudeSelected:String(newLngLat.lng)});

		this.props.isMapChanged(true);
	}
	submitSearchMap(event){
		let seperatedLocation=$(event.currentTarget).attr('data_location').split(',').reverse();

		this.setState({isMapSelected:true});//submit button enabled
	  	this.props.isMapChanged(true);
		this.setState({searchMapInputValue:$(event.currentTarget).attr('name_location')});
		this.setState({searchResults:[]});
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(seperatedLocation, prevZoom);

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
		if(neshanCircle && neshanMarker)
		{
			neshanMap.removeLayer(neshanCircle);
			neshanMap.removeLayer(neshanMarker);
		}
		neshanCircle=L.circle(seperatedLocation, 2000).addTo(neshanMap);
        neshanMarker= L.marker(seperatedLocation, {
            icon: myIcon,
            draggable: true
        }).addTo(neshanMap);


		neshanMarker.on('dragend', (event)=>{
			let lngLat = event.target._latlng;
			this.updateMapSettings(lngLat);
		});

		this.setState({lattitudeSelected:seperatedLocation[0]});
		this.setState({longitudeSelected:seperatedLocation[1]});
	  	this.setState({showAddressDetail:true});
	}

	callSubmitAddressApi(){
		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
		let error_messages={};
    	let photographerUid = (directAndPhotographerSelected) ? this.props.photographerUid : "" ;
    	let addressDetailParameter = (this.state.checkStudioSelected) ? this.state.searchMapInputValue: this.state.addressDetail ;
    	let inStudioParameter = (this.state.checkStudioSelected) ? '&address[in_studio]=true' : '';
		let body="address[longtitude]="+this.state.longitudeSelected+"&address[lattitude]="+this.state.lattitudeSelected+"&address[input]="+this.state.searchMapInputValue+"&address[detail]="+addressDetailParameter+"&project_slug="+this.props.project_slug+"&photographer="+photographerUid+inStudioParameter;
        let url=this.props.link+'/api/v1/submit_address';

        return fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{

                this.setState({wait:false});
				this.setState({isMapSelected:true});
            	if (parseInt(response.status) !== 202) {
            		response.json().then((object) =>{
                		error_messages["submit_address"] = object.messages;
                		this.setState({error_messages: error_messages});
    				});
            	}
                else{
                	response.json().then((object) =>{
                		let totalDays=[1,2,3,4,5,6,7];
			            let unAvailableDays = [];
			            if(object.days)
			            {
			            	for (var i = 0; i < totalDays.length; i++) {
				                if(!object.days[0].includes(totalDays[i]))
				                    unAvailableDays.push(totalDays[i]);
				            }
				        }
			            var data = {
							avatarUrl: object.avatar_url,
							availableHours: object.available_hours,
							photographerName: object.photographer_name,
							unAvailablePhotographerDays:unAvailableDays
					    }
						this.props.whenWhereFieldValuesCallBack(data);
    				});

                }



            })
            .catch(function(e){console.log(e)});
	}
	handleCheckStudioSelectedChange(event){
    	this.setState({checkStudioSelected: event.target.checked});
   		let photographerDirectFirstName = this.props.photographerDirectName.substring(0,this.props.photographerDirectName.indexOf(" ")).charAt(0);
   		let photographerDirectLastName = this.props.photographerDirectName.substring(this.props.photographerDirectName.indexOf(" ")+1,this.props.photographerDirectName.length);
    	if(event.target.checked)
    	{
    		this.setState({searchMapInputValue: 'عکاسی در آتلیه '+photographerDirectFirstName +". "+photographerDirectLastName});
    		this.goToCity(this.props.studioLat,this.props.studioLng);
    		neshanMap.dragging.disable();
    		neshanMarker.dragging.disable();
    	}
    	else{
    		this.setState({searchMapInputValue: ''});
    		if($($(".region-example.selected")[0]).attr('lat'))
    			this.goToCity($($(".region-example.selected")[0]).attr('lat'),$($(".region-example.selected")[0]).attr('lng'));
    		else
    			this.goToCity($($("option:selected")[0]).attr('lat'),$($("option:selected")[0]).attr('lng'));
    		neshanMap.dragging.enable();
    		neshanMarker.dragging.enable();
    	}
    }
	render () {
		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
		let primarySampleCityList = <React.Fragment></React.Fragment>;
		let moreSampleCityOptions = <React.Fragment></React.Fragment>;
		if(this.props.photographerDirectCityName!="")
		{
			primarySampleCityList =
			this.state.sampleCities.map((item,i)=>{
				if(i<5)
				{
					return(
						<span key={i} id={i} className="region-example" value={item.name} onClick={this.handleMapExampleClick} lat={item.latitude} lng={item.longitude}>{' '+(item.name)+' '}</span>
					);
				}
			});
			moreSampleCityOptions = this.state.sampleCities.map((item,i)=>{
				if(i>=5)
				{
					return(
						<option key={i} id={i} value={item.name} lat={item.latitude} lng={item.longitude}>{' '+(item.name)+' '}</option>
					);
				}
			});
		}
		let searchResults = <React.Fragment></React.Fragment>;
		if(this.state.searchResults.length>0)
		{
			searchResults = <React.Fragment></React.Fragment>;
			let searchItems = this.state.searchResults.map((item,i)=>{
				/*let localities = <React.Fragment></React.Fragment>;
				if(item.localities.length > 0 && item.type !== 'city' && item.type !== 'state')
				{
					localities =item.localities.map((item,i)=>{
						if(i<=2)
							return(<span  className="sg-separator" key={i}>{item}</span>);
					});
				}
				let districts = <React.Fragment></React.Fragment>;
				if(item.districts.length > 0 && item.type !== 'city' && item.type !== 'state')
				{
					districts =item.districts.map((item,i)=>{
						if(i<=2)
							return(<span key={i}>{item}</span>);
					});
				}*/
				let location = [item.location.x,item.location.y];
				return(
					<li className="item-suggest" data_location={String(location)} name_location={item.name} onClick={this.submitSearchMap} key={i}>
						<p className="sg-title">
							{item.name}
							{/*(item.alt_name && item.alt_name.trim())&&' ('+item.alt_name+') '*/}

							{/*(item.type) &&*/}

							{/*<span className="sg-type lightgray">{' ('+this.getLocationTypeIcon(item.type)+')'}</span>*/}
							<span >{' ('+item.type+') '}</span>

						</p>
						<span className="sg-locality gray ellipsis">
								{/*(item.districts.length > 0 && item.type !== 'city' && item.type !== 'state') &&
								 	<span className="sg-separator">
									{districts}
									</span>
								*/}
								{/*(item.province && item.province !== item.city) &&*/}

								<span className="sg-separator">{item.province}</span>

								{(item.city) &&
									<span>{item.city}</span>
								 }
								{/*(item.localities.length > 0 && item.type !== 'city' && item.type !== 'state') &&*/}
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
			searchResults = <p>نتیجه ای پیدا نشد.</p>;
		}
		let mapHeight=(mobileDisplay)?'350px':'400px';
		let map = <div className="col" data-type="سیدار مپ">

			<div className='_1WR' id="map" style={{width: '100%', height: mapHeight, position: 'relative', overflow: 'hidden' , opacity: (this.state.checkStudioSelected?'0.3':'1'), pointerEvents: (this.state.checkStudioSelected?'none':'all')}}>

				<div className="searchContainer">
				<div className="_37e">
					<input className="searchmap _3u5" type="search" id="fg-cm-search" name="fg-cm-search" autoComplete="off" required="true" placeholder="نام منطقه/محله را وارد کنید..." value={this.state.searchMapInputValue} onChange={this.handleSearchMapInputChange} />
					<div className="region-example-container">
						<span className="_2EU">شهر:</span>
						{primarySampleCityList}
						<select style={{border: '0 solid', font: "12px/1.5 'Helvetica Neue', Arial, Helvetica, sans-serif"}} className="region-example"  id="more_cities" onChange={this.handleSelectOptionsChange}>
							{moreSampleCityOptions}
						</select>
					</div>
				</div>
				<div className="searchresult" id="fo-cedar-result">{searchResults}</div>
				</div>
			</div>
		</div>;
		return (
			<React.Fragment>
			  	<div className="container">
			    	<div className="main" style={{height:this.mainHeight}}>
      					<div className="wrapper">
                <div className="row">
                  <div className="col">
                  <h3 className="text-right">
                  کجا میخواهید عکاسی کنید؟
                  </h3>
					{this.state.hasStudio?<div className=" text-center alert alert-success" style={{border: (this.state.checkStudioSelected?'3px solid #7aa9ff':'none')}}>
					<h5 className="text-center"> این عکاس آتلیه دارد، میخواهید در آتلیه او عکاسی کنید؟ </h5>
					<label style={{letterSpacing: '1px'}}>
					<input type="checkbox" id="studio-check" checked={this.state.checkStudioSelected} onChange={this.handleCheckStudioSelectedChange}/>
			          بله، میخواهم بروم به آتلیه.</label>
			         </div>:<div></div>}
                  </div>
                </div>
								<div className="row">
									{map}
	      				</div>
                <div className="row">
                <p className="alert alert-warning text-center">
                <i className="fa fa-2x fa-map-marker"></i>
                از وارد کردن نقطه دقیق روی نقشه اطمینان حاصل کنید.
                </p>
                </div>
  						</div>
  						{/*<div className="row">
			                <h3 className="title text-center">
			                انتخاب آدرس مکان عکاسی
			                </h3>
			                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}

							<div className="col-xs-12">

								<div className="row" style={{marginTop:'5px'}}>
	      							<div className="col-xs-12">
										<div className="form-group">
											<label htmlFor="address-detail"> آدرس دقیق محل: </label>
											<textarea
											className="form-control"
											name="address-detail"
											id="address-detail"
											rows="7"
											required
											placeholder="جزئیات آدرس، برای مثال کوچه، پلاک، طبقه یا محل ملاقات با عکاس"
											onChange={this.handleAddressDetailChange}
											data-parsley-trigger="keyup"
											></textarea>
										</div>
									</div>
								</div>
							</div>
						</div>*/}
						<div className="row full-continue-btn" style={{position: (this.footerPosition),width: (this.footerWidth),
							bottom: (this.footerBottom),
							left: (this.footerLeft),
							padding: (this.footerPadding)}}>
					        <div className="col-sm-4 col-sm-offset-4">
					        	<ContinueButton
					              handleSubmitButton={this.handleSubmitButton}
					              continueButtonDisabled={!this.state.isMapSelected}
					              wait={this.state.wait}
                                    payment={false}
					          	/>
					        </div>
					        {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
					        <br />
					        {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
							{/*<Tracker
		      					step={this.props.step}
		      				/>*/}
				      </div>
				      <br />
					</div>
				</div>
				<BookFooter
					backButtonDisabled={false}
					previousStep={this.props.previousStep}
					handleSubmitButton={this.handleSubmitButton}
					continueButtonDisabled={( !this.state.isMapSelected)}
					wait={this.state.wait}
					payment={false}
				/>
				<WaitingPopup wait={this.state.wait}/>
				<AddressDetailsPopup
				show={this.state.addressDetailsPopupShow}
				addressDetailInitCallBack={(val)=>{this.setState({addressDetail: val})}}
				submitButtonCallBack={()=>this.addressDetailPopupSubmitButtonClicked()}/>
			</React.Fragment>
		);
	}
}
