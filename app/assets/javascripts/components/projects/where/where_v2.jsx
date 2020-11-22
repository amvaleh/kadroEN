class WhereV2 extends React.Component {

	constructor(props) {
		super(props);
		this.state = {
			addressDetail:'',
			error_messages:{},
			lattitudeSelected:'',
			longitudeSelected:'',
			addressInput:'',
			isMapSelected:false,
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
			receivedAllCities:false,
			locationIsSelected:false,
			isMapChanged:false,
			//cloned from
			receiveType: '',
            shoot_type_selected_id:'',
            deliveryAtLocation:'',
            deliverySectionClicked: false,
            inLocationPackages:[],
            notInLocationPackages:[],
            recommendationGalleryIndex:0,
            recommendationMemoryIndex:0,
            directInfoReceived:false,
            recommendationHour:0,
            shootTypeSelectedTitle:'',
			shootTypeSelectedExtendedHourCost:'70000',
			shootLocations:[],
			shootStudios:[],
			showLocations:false,
			showStudios:false,
			studioMarkers:[],
			locationMarkers:[],
			prevZoom:12,
			studioPointsInRange:0,
			selectedCity:'تهران',
			myLocationFilterSelected:true,
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
		this.findIndexOfHour=this.findIndexOfHour.bind(this);
		this.getLocationPins=this.getLocationPins.bind(this);
		this.getStudioPins=this.getStudioPins.bind(this);
		this.handleLocationCheckBoxChange=this.handleLocationCheckBoxChange.bind(this);
		this.handleStudioCheckBoxChange=this.handleStudioCheckBoxChange.bind(this);
		this.handleMyLocationCheckBoxChange=this.handleMyLocationCheckBoxChange.bind(this);
		this.handlePopupClick=this.handlePopupClick.bind(this);
		this.footerPosition='';
		this.footerWidth='';
		this.footerBottom='';
		this.footerLeft='';
		this.footerPadding='';
		this.mainHeight='';
		this.searchContainerClicked=false;
		this.searchContainerScrolling=false;
		this.showLocationsCheckboxRef=React.createRef();
		this.showStudiosCheckboxRef=React.createRef();
		this.typingTimer;                //timer identifier for search input
		this.doneTypingInterval = 1500;  //time in ms, 1.5 second for search input
		this.resetMap = this.resetMap.bind(this)
	}
	componentDidMount(){
		this.getSampleCities();
		$("#more_cities").prepend("<option value=''>بیشتر...</option>");
        this.props.isServiceSelected_callBack3(true);
		this.props.isMapShownCallBack(true);
		window.reactMapPopupCallBack = (latLng,title) => {
			console.log(latLng,title);this.handlePopupClick(latLng,title)};//make function globally accessible
		this.getLocationPins(this.props.shoot_type_selected_id);
		this.getStudioPins(this.props.shoot_type_selected_id);

		var $input = $('#search-input');
		
		//on keydown, clear the countdown 
		$input.on('keydown', function () {
			clearTimeout(this.typingTimer);
		});
  
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
		if(this.props.step==1 && this.state.mapInitCount==0 && this.state.receivedAllCities)
    	{
    		let target = $('#location-pick');
	        if( target.length ) {
	          $('html, body').stop().animate({
	              scrollTop: target.offset().top
	          }, 1000);
	        }
    		neshanMapInitialize(35.699739, 51.338097);
    		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
	    	let cityIsFinded=false;
    		if(directAndPhotographerSelected)
    		{
				this.setState({selectedCity:this.props.photographerDirectCityName}) ;

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

				this.resetMap();
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
				if(!this.state.showStudios)
				{
					neshanMarker= L.marker(newCenter, {
						icon: myIcon,
						draggable: true
					}).addTo(neshanMap);

					neshanMarker.on('dragend', (event)=>{
						this.resetMap();
						let lngLat = event.target._latlng;
						this.updateMapSettings(lngLat);
					});
				}
				this.updateMapSettings(newCenter);
				
			});
			neshanMarker.on('dragend', (event)=>{
				this.resetMap();
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
			this.resetMap();
		  	this.setState({showAddressDetail:true});
    		this.setState({mapInitCount:1});

    	}
	}
	componentWillReceiveProps(nextProps){
		if(this.state.locationWasSelected){ //if service packages come from shoot type submit api change the package information
	        if((nextProps.inLocationPackages!==this.props.inLocationPackages || nextProps.directInfoReceived!==this.props.directInfoReceived))
	        {
	          this.setState({inLocationPackages:nextProps.inLocationPackages});
	          this.setState({notInLocationPackages:nextProps.notInLocationPackages});
	          this.setState({directInfoReceived:nextProps.directInfoReceived});
	        }
	        if(nextProps.recommendationGalleryIndex!==this.props.recommendationGalleryIndex || nextProps.recommendationMemoryIndex!==this.props.recommendationMemoryIndex)
	        {
	          this.setState({recommendationGalleryIndex:nextProps.recommendationGalleryIndex});
	          this.setState({recommendationMemoryIndex:nextProps.recommendationMemoryIndex});
	        }
	    }
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
        }
        if(nextProps.shoot_type_selected_id!==this.props.shoot_type_selected_id)
        {
			this.resetMap();
			this.setState({shoot_type_selected_id:nextProps.shoot_type_selected_id});
			this.getLocationPins(nextProps.shoot_type_selected_id);
			this.getStudioPins(nextProps.shoot_type_selected_id);
			this.setState({myLocationFilterSelected:true});
			this.setState({showLocations:false});
			this.setState({showStudios:false});
			this.state.studioMarkers.forEach(element => {
				neshanMap.removeLayer(element);
			});
			this.state.locationMarkers.forEach(element => {
				neshanMap.removeLayer(element);
			});
			this.props.setShowStudiosCallBack(false);
        }
        if(nextProps.mapIsSubmitted!==this.props.mapIsSubmitted)
        {
            if(nextProps.mapIsSubmitted)
            {
            	this.props.isMapShownCallBack(false);//for avoiding submit button from submitting map in future
            	this.handleSubmitButton();
            }
        }

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
        			this.setState({locationIsSelected:false});//resubmit location
	        		this.setState({checkStudioSelected:false});
	        		this.setState({searchMapInputValue: ''});
		    		if($($(".region-example.selected")[0]).attr('lat'))
		    		{
						this.setState({selectedCity:$($(".region-example.selected")[0]).attr('value')}) ;
		    			this.goToCity($($(".region-example.selected")[0]).attr('lat'),$($(".region-example.selected")[0]).attr('lng'));
		    		}
		    		else if(this.goToCity($($("option:selected")[0]).attr('lat')))
		    		{
						this.setState({selectedCity:$($("option:selected")[0]).attr('value')}) ;
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
	    this.setState({recommendationHour: nextProps.recommendationHour});//this comes from just shoot_type submit api	    
        this.setState({shootTypeSelectedTitle:nextProps.shootTypeSelectedTitle});
        this.setState({shootTypeSelectedExtendedHourCost:nextProps.shootTypeSelectedExtendedHourCost});
	}
	resetMap(){
		this.setState({isMapSelected:true});//submit button enabled
	  	this.props.isMapChangedCallBack(true);
	  	this.setState({locationIsSelected:false});
        this.props.isServiceSelected_callBack3(true);
		this.props.isMapShownCallBack(true);
		this.setState({addressDetail:''});
	}
	getLocationPins(shootTypeId){
		let url=this.props.link+'/api/v3/give_all_locations?shoot_type_id='+shootTypeId;
		$.get(url, (data, status)=>{
			this.setState({shootLocations:data.shoot_locations});
		});
	}
	getStudioPins(shootTypeId){
		let url=this.props.link+'/api/v3/give_all_studios?shoot_type_id='+shootTypeId;
		$.get(url, (data, status)=>{
			this.setState({shootStudios:data.shoot_locations});
		});
	}
	handleMyLocationCheckBoxChange(event){
		if(!this.state.myLocationFilterSelected)
		{	
			this.setState({myLocationFilterSelected: true});
			if(this.state.showLocations)
			{
				this.state.locationMarkers.forEach(element => {
					neshanMap.removeLayer(element);
				});
				this.setState({showLocations: false});
			}
			else if(this.state.showStudios)
			{
				this.resetMap();
				this.setState({showStudios: false});
				this.props.setShowStudiosCallBack(false);
				neshanMap.scrollWheelZoom.enable();
				neshanMap.doubleClickZoom.enable();	
				neshanMap.boxZoom.enable();
				neshanMap.zoomControl.enable();
				neshanMap.setZoom(this.state.prevZoom);
				neshanCircle.setRadius(2000);
				neshanMarker= L.marker(neshanMap.getCenter(), {
					icon: myIcon,
					draggable: true
				}).addTo(neshanMap);

				neshanMarker.on('dragend', (event)=>{
					this.resetMap();
					let lngLat = event.target._latlng;
					this.updateMapSettings(lngLat);
				});

				this.state.studioMarkers.forEach(element => {
					neshanMap.removeLayer(element);
				});
			}
		}
		else{
			this.setState({myLocationFilterSelected: false});
		}
	}
	handlePopupClick(latLng,title){
		
		neshanMap.removeLayer(neshanMarker);
		neshanMarker= L.marker(latLng, {
			icon: myIcon,
			draggable: true
		}).addTo(neshanMap);
		
		neshanMarker.on('dragend', (event)=>{

			this.resetMap();
			let lngLat = event.target._latlng;
			this.updateMapSettings(lngLat);
		});
		
		this.updateMapSettings(latLng);
		this.setState({addressDetail:title},()=>{

		this.handleSubmitButton();
		});
	}
	handleLocationCheckBoxChange(event){
		
		if(!this.state.showLocations)
		{	
			neshanMap.setZoom(12);
			this.setState({showLocations: true});
			let markers = [];
			this.state.shootLocations.forEach(element => {
				let btn = `<button class='btn btn-blue location-popup-btn' onclick="mapPopupCallBack({lat:${element.lat},lng:${element.lng}},'${element.title}')">انتخاب</button>`;
				let popup = L.popup().setContent(element.title+'<br><br>'+btn);

				let marker = new L.marker([element.lat, element.lng], {
					icon: locationIcon
				})
				.bindPopup(popup)
				.addTo(neshanMap);
				markers.push(marker);
			});
			this.setState({locationMarkers:markers});

			if(this.state.showStudios)
			{
				this.resetMap();
				this.setState({showStudios: false});
				this.props.setShowStudiosCallBack(false);
				neshanMap.scrollWheelZoom.enable();
				neshanMap.doubleClickZoom.enable();	
				neshanMap.boxZoom.enable();
				neshanMap.zoomControl.enable();
				neshanCircle.setRadius(2000);
				neshanMarker= L.marker(neshanMap.getCenter(), {
					icon: myIcon,
					draggable: true
				}).addTo(neshanMap);

				neshanMarker.on('dragend', (event)=>{
					this.resetMap();
					let lngLat = event.target._latlng;
					this.updateMapSettings(lngLat);
				});

				this.state.studioMarkers.forEach(element => {
					neshanMap.removeLayer(element);
				});
			}
			else if(this.state.myLocationFilterSelected)
			{
				this.setState({myLocationFilterSelected: false});
			}
		}
		else{
			this.setState({showLocations: false});
			this.state.locationMarkers.forEach(element => {
				neshanMap.removeLayer(element);
			});
		}
		  
	}

	handleStudioCheckBoxChange(event){
		//reset map
		this.resetMap();
		let prevState = this.state.showStudios;
		
		if(!this.state.showStudios)
		{	
			this.setState({showStudios: true});
			this.props.setShowStudiosCallBack(true);
			this.setState({prevZoom:neshanMap.getZoom()});
			neshanMap.setZoom(11);
			neshanMap.scrollWheelZoom.disable();
			neshanMap.doubleClickZoom.disable();	
			neshanMap.boxZoom.disable();
			neshanMap.zoomControl.disable();
			neshanCircle.setRadius(7300);
			neshanMap.removeLayer(neshanMarker);
			//disable and uncheck show location checkbox and remove markers
			if(this.state.showLocations)
			{
				this.state.locationMarkers.forEach(element => {
					neshanMap.removeLayer(element);
				});
				this.setState({showLocations: false});
			}
			else if(this.state.myLocationFilterSelected)
			{
				this.setState({myLocationFilterSelected: false});
			}
			/////////////////////////
			let points=0;
			let markers = [];
			this.state.shootStudios.forEach(shootStudio => {
				if(neshanCircle.contains([shootStudio.lat, shootStudio.lng],shootStudio.title))
				{
					points+=1;
					let marker = new L.marker([shootStudio.lat, shootStudio.lng], {
						icon: studioIcon
					})
					.addTo(neshanMap);
					markers.push(marker);
				}
			});
			this.setState({studioPointsInRange:points});
			this.setState({studioMarkers:markers});

			
		}
		else
		{
			this.setState({showStudios: false});
			this.props.setShowStudiosCallBack(false);
			neshanMap.scrollWheelZoom.enable();
			neshanMap.doubleClickZoom.enable();	
			neshanMap.boxZoom.enable();
			neshanMap.zoomControl.enable();
			neshanMap.setZoom(this.state.prevZoom);
			neshanCircle.setRadius(2000);
			neshanMarker= L.marker(neshanMap.getCenter(), {
				icon: myIcon,
				draggable: true
			}).addTo(neshanMap);

			neshanMarker.on('dragend', (event)=>{

				this.resetMap();
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});

			this.state.studioMarkers.forEach(element => {
				neshanMap.removeLayer(element);
			});
		}
		  
	}
	getSampleCities(){
		let url=this.props.link+'/api/v2/active_cities';
		$.get(url, (data, status)=>{
			this.setState({sampleCities:data.cities});
			this.setState({receivedAllCities:true});
		});
	}
    handleSelectOptionsChange(event){
    	$('.region-example').removeClass('selected');
    	if(event.target.value!=="")
			$('#more_cities').addClass('selected');
		
		this.setState({selectedCity:$($("option:selected")[0]).attr('value')}) ;
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
		this.props.isMapChangedCallBack(false);
        this.props.isServiceSelected_callBack3(false);
        this.props.isMapShownCallBack(false);
    	//this.props.nextStep();
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
		if(!this.state.checkStudioSelected && !this.state.showStudios)
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
			this.props.isMapChangedCallBack(false);
			this.props.isServiceSelected_callBack3(false);
        	this.props.isMapShownCallBack(false);
	    	//this.props.nextStep();
	    }
	    
	}
	handleAddressDetailChange(event){
		this.setState({addressDetail: event.target.value})
	}
	handleMapExampleClick(event){
		$('.region-example').removeClass('selected');
		$(event.target).addClass('selected');
		this.setState({selectedCity:$(event.target).attr('value')}) ;
	  	this.goToCity($(event.target).attr('lat'),$(event.target).attr('lng'));
	}
	goToCity(lat,lng){
		let seperatedLocation=[lat,lng];
		this.resetMap();
		this.setState({searchResults:[]});
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(seperatedLocation, prevZoom);

		neshanMap.on('drag', ()=>{
			let newCenter = neshanMap.getCenter();
			neshanMap.removeLayer(neshanMarker);
			if(!this.state.showStudios)
			{
				neshanMarker= L.marker(newCenter, {
					icon: myIcon,
					draggable: true
				}).addTo(neshanMap);

				neshanMarker.on('dragend', (event)=>{

					this.resetMap();
					let lngLat = event.target._latlng;
					this.updateMapSettings(lngLat);
				});
			}
			this.updateMapSettings(newCenter);
			
		});
		if(neshanCircle && neshanMarker)
		{
			neshanMap.removeLayer(neshanCircle);
			neshanMap.removeLayer(neshanMarker);
		}
		
		
        if(!this.state.showStudios)
		{
			neshanMarker= L.marker(seperatedLocation, {
				icon: myIcon,
				draggable: true
			}).addTo(neshanMap);

			neshanMarker.on('dragend', (event)=>{
				this.resetMap();
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
			neshanCircle=L.circle(seperatedLocation, 2000).addTo(neshanMap);
		}
		else{
			neshanCircle=L.circle(seperatedLocation, 7300).addTo(neshanMap);
		}
		this.setState({lattitudeSelected:seperatedLocation[0]});
		this.setState({longitudeSelected:seperatedLocation[1]});
	  	this.setState({showAddressDetail:true});
	}
	searchMap(query){
		//let defaultSortedProvincesList=['تهران','البرز','خراسان رضوی', 'فارس', 'اصفهان', 'آذربایجان شرقی','یزد',"گیلان",'خوزستان','قزوین','آذربایجان غربی','زنجان','مازندران',,'همدان','کرمانشاه','کرمان','لرستان','گلستان','کردستان','مرکزی','اردبیل','قم','بوشهر','خراسان شمالی','خراسان جنوبی','سمنان','چهارمحال و بختیاری','کهگیلویه و بویراحمد','سیستان و بلوچستان','هرمزگان'];
		let allowedPlaceTypes=["restaurant","cafe","park","fast_food","university","hotel","residential_complex","subway_station","amusement_park"];
		let searchResults=[];
		this.setState({wait:true});
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
		
	    return $.ajax({
		 url: "https://api.neshan.org/v1/search?term="+query+"&lat="+queryLat+"&lng="+queryLng,
		 type: "GET",
		 beforeSend: function(xhr){xhr.setRequestHeader('Api-Key', 'service.zxfXcIUQnzlR97KubhRmAZXvwvOKdqBNXRKazF0X');},
		 success: (res)=> {
		 	if(res.items.length==0){
				this.setState({noSearchResult:true});
				this.setState({wait:false});
			}
			else{
				res.items.map((item,i) =>{
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
						if(regionArray.length==2)
						{
							city=regionArray[0];
							provinceCompleteName=regionArray[1];
						}
						else{
							city=regionArray[regionArray.length-2];
	            			provinceCompleteName=regionArray[regionArray.length-1];
						}
	            		
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
		            if(item.category=='place' && allowedPlaceTypes.includes(item.type))
		            {
						searchResultItem.type1=item.type;
						searchResultItem.category=item.category;
		            	searchResultItem.type=category;
		            	searchResultItem.location=item.location;
		            	searchResultItem.city=city;
		            	searchResultItem.province1=province;
		            	searchResultItem.province=provinceCompleteName;
		            	searchResultItem.name=item.title;
		            	searchResultItem.localities=(item.neighbourhood)?item.neighbourhood:"";
						searchResults.push(searchResultItem);
						/*console.log('---------');
						console.log(`neshan place result ${i}:`);*/
					}
					else if(item.category!='place' ){
						searchResultItem.type1=item.type;
						searchResultItem.category=item.category;
		            	searchResultItem.type=category;
		            	searchResultItem.location=item.location;
		            	searchResultItem.city=city;
		            	searchResultItem.province1=province;
		            	searchResultItem.province=provinceCompleteName;
		            	searchResultItem.name=item.title;
		            	searchResultItem.localities=(item.neighbourhood)?item.neighbourhood:"";
						searchResults.push(searchResultItem);
						/*console.log('---------');
						console.log(`neshan result ${i}:`);*/
					}
				 });
				/////////////////////////////////// google results
				let location = new google.maps.LatLng(queryLat,queryLng);
				const request = {
					location: location,
					radius: '1000',
					query: query
				};
				let sortingTypes = ['locality','sublocality','region','neighborhood','municipal','route','intersection','place','restaurant','cafe', 'museum','park','shopping_mall','university'];
				let allowedGoogleTypes= ['locality','sublocality','neighborhood','route','intersection','restaurant','cafe', 'museum','park','shopping_mall','university'];
				return service.textSearch(request, (results, status) => {
					if (status === google.maps.places.PlacesServiceStatus.OK) {
						results.forEach((item,i)=>{
							let itemTypeIsAllowed = false;
							let itemType = item.types[0];
							item.types.forEach(element=>{
								allowedGoogleTypes.forEach(type =>{
									if(element==type)
									{
										itemTypeIsAllowed=true;
										itemType=element;
									}
									
								});
							});
							
							if(item.name.includes(query) && itemTypeIsAllowed)
							{
								let city="";
								let provinceCompleteName="";
								let province = "";

								let regionArray=item.formatted_address.split("،");
								/*console.log('---------');
								console.log(`google result ${i}:`);*/
								regionArray.forEach((element,i) => {
									if(i==0 && element.includes("استان"))
									{
										provinceCompleteName=element;
										province = provinceCompleteName.replace('استان','').replace(/\s/g, '');
										city = regionArray[i+1].replace(/\s/g, '');
									}
									else if(i==regionArray.length-1 && element.includes("استان")){
										provinceCompleteName=element;
										province = provinceCompleteName.replace('استان','').replace(/\s/g, '');
										city = regionArray[i-1].replace(/\s/g, '');
									}
								});

								let location = {x:item.geometry.location.lng(),y:item.geometry.location.lat()};
								let searchResultItem={};
								let categoryText="";
								let placeTypes = ['restaurant','cafe','museum','park','shopping_mall','university'];
								if(placeTypes.includes(itemType))
									categoryText='مکان';
								else if(['route','intersection'].includes(itemType))
									categoryText=" خیابان یا بزرگراه";
								else if(['sublocality','neighborhood'].includes(itemType))
									categoryText="محله یا روستا";
								else 
									categoryText="شهر یا شهرستان";

								searchResultItem.type=categoryText;
								searchResultItem.category=itemType;
								searchResultItem.location=location;
								searchResultItem.city=city;
								searchResultItem.province1=province;
								searchResultItem.province=provinceCompleteName;
								searchResultItem.name=item.name;
								searchResultItem.localities="";
								searchResults.push(searchResultItem);
							}
						});
						let placeTypeOrderingIndexes=[];

						for (let i=0; i<sortingTypes.length; i++)
							placeTypeOrderingIndexes[sortingTypes[i]] = i;

						var object = {};
						//delete both title and locality duplicates from total results
						for (let index = searchResults.length-1; index >=0; index--) {
							
							if(!object[searchResults[index].name+searchResults[index].localities])
							{
								object[searchResults[index].name+searchResults[index].localities] =index;
							}
							else
							{
								searchResults.splice(index,1);
							}
						}
						
						//sort total results by types
						searchResults.sort( function(a, b) {
							return (placeTypeOrderingIndexes[a.category] - placeTypeOrderingIndexes[b.category]);	
						});
						let citySelectedResults=[];
						//get results which their city is selected city from user
						let citySpecifiedIndexes=[];
						searchResults.forEach((item,i)=>{
							if(item.city==this.state.selectedCity)
							{
								citySelectedResults.push(item);
								citySpecifiedIndexes.push(i);
							}
						});

						//delete results from specified city from total results
						for (let index = citySpecifiedIndexes.length-1; index >=0; index--) {
							searchResults.splice(citySpecifiedIndexes[index],1);
							
						}
						//sort user city results by types
						citySelectedResults.sort( function(a, b) {
							return (placeTypeOrderingIndexes[a.category] - placeTypeOrderingIndexes[b.category]);	
						});

						//put sorted user city results on top of total results
						for (let index = citySelectedResults.length-1; index >=0; index--) {
							searchResults.unshift(citySelectedResults[index]);
						}
						this.setState({wait:false});
						this.setState({searchResults:searchResults});
	  					this.setState({noSearchResult:false});
					}
				});
				
			}
		 }
	  });
	  


	}
	handleSearchMapInputChange(event){
		this.setState({searchMapInputValue: event.target.value});
		this.setState({searchResults:[]});
		
		clearTimeout(this.typingTimer);
		if(event.target.value.length>1)
		{
			this.typingTimer = setTimeout(this.searchMap.bind(null, event.target.value), this.doneTypingInterval);
		}
	  		
	  	//this.setState({showMap:false});
	  	//this.props.showMapCallBack(false);
	}
	updateMapSettings(newLngLat){
		let newLocation = [String(newLngLat.lat),String(newLngLat.lng)];
		let prevZoom = neshanMap.getZoom();
		neshanMap.setView(newLocation, prevZoom);
		let prevRadius = neshanCircle.getRadius();
		neshanMap.removeLayer(neshanCircle);

		neshanCircle=L.circle(newLocation, prevRadius).addTo(neshanMap);
		if(this.state.showStudios)
		{
			let points=0;
			let markers = [];
			this.state.studioMarkers.forEach(element => {
				neshanMap.removeLayer(element);
			});
			this.state.shootStudios.forEach(shootStudio => {
				if(neshanCircle.contains([shootStudio.lat, shootStudio.lng],shootStudio.title))
				{
					points+=1;
					let marker = new L.marker([shootStudio.lat, shootStudio.lng], {
						icon: studioIcon
					})
					.addTo(neshanMap);
					markers.push(marker);
				}
			});
			this.setState({studioPointsInRange:points});
			this.setState({studioMarkers:markers});
		}
			

		this.setState({lattitudeSelected:String(newLngLat.lat)});
		this.setState({longitudeSelected:String(newLngLat.lng)});
		this.setState({locationIsSelected:false});
		this.props.isMapChangedCallBack(true);
        this.props.isServiceSelected_callBack3(true);
       	this.props.isMapShownCallBack(true);
	}
	submitSearchMap(event){
		let seperatedLocation=$(event.currentTarget).attr('data_location').split(',').reverse();

		this.resetMap();
		this.setState({searchMapInputValue:$(event.currentTarget).attr('name_location')});
		this.setState({searchResults:[]});
		let prevZoom = neshanMap.getZoom();
		this.updateMapSettings({lat:seperatedLocation[0],lng:seperatedLocation[1]});
		
		neshanMap.setView(seperatedLocation, prevZoom);

		neshanMap.on('drag', ()=>{
			let newCenter = neshanMap.getCenter();
			neshanMap.removeLayer(neshanMarker);
			if(!this.state.showStudios)
			{
				neshanMarker= L.marker(newCenter, {
					icon: myIcon,
					draggable: true
				}).addTo(neshanMap);

				neshanMarker.on('dragend', (event)=>{
					this.resetMap();
					let lngLat = event.target._latlng;
					this.updateMapSettings(lngLat);
				});
			}
		});
		if(neshanCircle && neshanMarker)
		{
			neshanMap.removeLayer(neshanCircle);
			neshanMap.removeLayer(neshanMarker);
		}
		
        if(!this.state.showStudios)
		{
			neshanMarker= L.marker(seperatedLocation, {
				icon: myIcon,
				draggable: true
			}).addTo(neshanMap);

			neshanMarker.on('dragend', (event)=>{
				this.resetMap();
				let lngLat = event.target._latlng;
				this.updateMapSettings(lngLat);
			});
			neshanCircle=L.circle(seperatedLocation, 2000).addTo(neshanMap);
		}
		else{
			neshanCircle=L.circle(seperatedLocation, 7300).addTo(neshanMap);
		}

		this.setState({lattitudeSelected:seperatedLocation[0]});
		this.setState({longitudeSelected:seperatedLocation[1]});
	  	this.setState({showAddressDetail:true});
	}
	findIndexOfHour(recommendation,hours){
        for (var i = 0; i < hours.length; i++) {
          if(hours[i]==recommendation)
          {
            return i;
          }
        }
        return 0;
    }
	callSubmitAddressApi(){
		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
		let error_messages={};
    	let photographerUid = (directAndPhotographerSelected) ? this.props.photographerUid : "" ;
    	let addressDetailParameter = (this.state.checkStudioSelected) ? this.state.searchMapInputValue:(this.state.showStudios)?'انتخاب محدوده عکاسی': this.state.addressDetail ;
		let inStudioParameter = (this.state.checkStudioSelected) ? '&address[in_studio]=true' : '';
		let showStudioParameter = (this.state.showStudios) ? '&address[show_studios]=true' : '';
		
		let body="address[longtitude]="+this.state.longitudeSelected+"&address[lattitude]="+this.state.lattitudeSelected+"&address[input]="+this.state.searchMapInputValue+"&address[detail]="+addressDetailParameter+"&project_slug="+this.props.project_slug+"&photographer="+photographerUid+inStudioParameter+showStudioParameter;
        let url=this.props.link+'/api/v3/accept_address';

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
                		let inLocationPackages = [];
						let notInLocationPackages = [];
						object['packages'].map((item,i) =>{
  
							if(item.is_full)
							{
								inLocationPackages.push(item);
							}
							notInLocationPackages.push(item);
						});
						
                		let recommendationGalleryIndex = 0;
                    	let recommendationMemoryIndex = 0;

		                this.setState({recommendationGalleryIndex: this.state.recommendationHour});
						this.setState({recommendationMemoryIndex: this.state.recommendationHour});
						this.setState({inLocationPackages:inLocationPackages});
						this.setState({notInLocationPackages:notInLocationPackages});

						this.setState({locationIsSelected:true});
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
							unAvailablePhotographerDays:unAvailableDays,
							addressLng: this.state.longitudeSelected,
							addressLat: this.state.lattitudeSelected,
							studioSelected: this.state.checkStudioSelected
					    }
				        if(this.state.checkStudioSelected)
						{
							data.addressInput="";
							data.addressDetail=this.state.searchMapInputValue;
						}
						else{
							data.addressInput=this.state.searchMapInputValue;
							data.addressDetail=this.state.addressDetail;
						}
			            
						this.props.whereFieldValuesCallBack(data);
						var target= $('#receive-type');
						if( target.length ) {
		                  $('html, body').stop().animate({
		                      scrollTop: target.offset().top
		                  }, 1000);
		                }
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
			{
				this.setState({selectedCity:$($(".region-example.selected")[0]).attr('value')}) ;
				this.goToCity($($(".region-example.selected")[0]).attr('lat'),$($(".region-example.selected")[0]).attr('lng'));
			}
			else
			{
				this.setState({selectedCity:$($("option:selected")[0]).attr('value')}) ;
				this.goToCity($($("option:selected")[0]).attr('lat'),$($("option:selected")[0]).attr('lng'));
			}
    		neshanMap.dragging.enable();
    		neshanMarker.dragging.enable();
    	}
    }
	render () {
		let filtersContainerMarginTop='';
		/*if(this.state.showStudios)
		{
			filtersContainerMarginTop = '24.1rem';
		}
		else{
			filtersContainerMarginTop = '25.5rem';
		}*/
		let headerNumber= (!this.props.direct)?'۲-':'۱-';
		let directAndPhotographerSelected= (!this.props.removeDirectPhotographer)?(this.props.photographerUid!==null && this.props.photographerUid.length>0):false;
		let primarySampleCityList = <React.Fragment></React.Fragment>;
		let moreSampleCityOptions = <React.Fragment></React.Fragment>;
		if(this.state.receivedAllCities)
		{
			primarySampleCityList =
			this.state.sampleCities.map((item,i)=>{
				if(i<4)
				{
					return(
						<span key={i} id={i} className="region-example" value={item.name} onClick={this.handleMapExampleClick} lat={item.latitude} lng={item.longitude}>{' '+(item.name)+' '}</span>
					);
				}
			});
			moreSampleCityOptions = this.state.sampleCities.map((item,i)=>{
				if(i>=4)
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
			searchResults = <p className="suggestion">نتیجه ای پیدا نشد.</p>;
		}
		let mapHeight=(mobileDisplay)?window.screen.availHeight*0.67:'500px';
		let mapContentsInDesktop = 
			<React.Fragment>
				<div className="row">
					<div className="col-sm-5" style={{padding: '0px'}}>
						<div className="searchContainer">
							
							<div className="_37e">
								<input className="searchmap _3u5" type="search" id="search-input" name="fg-cm-search" autoComplete="off" placeholder="جستجوی نام منطقه/محله..." value={this.state.searchMapInputValue} onChange={this.handleSearchMapInputChange} />
								<div className="region-example-container">
									<span className="_2EU">شهر:</span>
									{primarySampleCityList}
									<select style={{border: '0 solid'}} className="region-example"  id="more_cities" onChange={this.handleSelectOptionsChange}>
										{moreSampleCityOptions}
									</select>
								</div>
							</div>	
							
							<div className="searchresult" id="fo-cedar-result">{searchResults}</div>
						</div>
					</div>
					<div className="col-sm-6 filter-checkboxes-container text-left" style={{padding: '0px'}}>
						
						<a onClick={this.handleMyLocationCheckBoxChange}>
							<div className={"filter-mylocation-box "+((this.state.myLocationFilterSelected)? 'selected':'')}>
								<input
								type="checkbox"
								checked={this.state.myLocationFilterSelected}
								onChange={this.handleMyLocationCheckBoxChange}
								/>
								<label className="my-location-check-label" htmlFor="my-location-check" >در محل</label>
							</div>
						</a>
						{(!this.state.hasStudio)?
						<a onClick={this.handleStudioCheckBoxChange}>
							<div className={"filter-studio-box "+((this.state.showStudios)? 'selected':'')}>
								<input
								type="checkbox"
								checked={this.state.showStudios}
								onChange={this.handleStudioCheckBoxChange}
								/>
								<label className="studios-check-label" htmlFor="studio-locations-check">آتلیه ها</label>
							</div>
						</a>
						:<React.Fragment></React.Fragment>}
					
						<a className={'filter-location-box-container '} onClick={this.handleLocationCheckBoxChange}>
							<div className={"filter-location-box "+((this.state.showLocations)? 'selected ':'')}>
								<input
								type="checkbox"
								checked={this.state.showLocations}
								onChange={this.handleLocationCheckBoxChange}
								/>
								<label className="locations-check-label" htmlFor="kadro-locations-check" >فضای باز</label>
							</div>
						</a>
						
						
					</div>
				</div>	

				{(!this.state.showStudios && this.state.showLocations)?
						<div className="row">
							<div className="col-sm-5 studio-points-box">
								<p className="text-right map-notice">
									لطفا مکان مورد نظر را با دقت انتخاب کنید.
								</p>
							</div>	
						</div>:<React.Fragment></React.Fragment>}
				{(!this.state.showStudios && !this.state.showLocations)?
						<div className="row">
							<div className="col-sm-5 studio-points-box">
								<p className="text-right  map-notice">
									نقشه را در مکان مورد نظر قرار دهید.
								</p>
							</div>
						</div>:<React.Fragment></React.Fragment>}
				{(this.state.showStudios)?
					<div className="row" style={{margin:'5px 0 0 0'}}>
						<div className="col-sm-5 studio-points-box">
							<p className="text-right map-notice" >
								لطفا محدوده ای که آتلیه می خواهید را انتخاب کنید.
							</p>
							{toPersianNumber(this.state.studioPointsInRange)+" آتلیه در محدوده یافت شد "}
						</div>
					</div>
				:<React.Fragment></React.Fragment>}
				
			</React.Fragment>
		let mapContentsInMobile = <React.Fragment>
			<div className="row">
				<div className="col-xs-10" style={{padding: '0px'}}>
					<div className="searchContainer">
						
						<div className="_37e">
							<input className="searchmap _3u5" type="search" id="search-input" name="fg-cm-search" autoComplete="off" placeholder="جستجوی نام منطقه/محله..." value={this.state.searchMapInputValue} onChange={this.handleSearchMapInputChange} />
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
			</div>
			<div className="row">
				
				<div className="filter-checkboxes-container text-left" style={{padding: '0px',marginTop:filtersContainerMarginTop}}>
					<a className={"col-xs-3 filter-mylocation-box-container"} onClick={this.handleMyLocationCheckBoxChange}>
						<div className={"filter-mylocation-box "+((this.state.myLocationFilterSelected)? 'selected':'')}>
							<input
							type="checkbox"
							checked={this.state.myLocationFilterSelected}
							onChange={this.handleMyLocationCheckBoxChange}
							/>
							<label className="my-location-check-label" htmlFor="my-location-check">در محل</label>
						</div>
					</a>
					{(!this.state.hasStudio)?
					<a className={"col-xs-3 filter-studio-box-container"} onClick={this.handleStudioCheckBoxChange}>
						<div className={"filter-studio-box "+((this.state.showStudios)? 'selected':'')}>
							<input
							type="checkbox"
							checked={this.state.showStudios}
							onChange={this.handleStudioCheckBoxChange}
							/>
							<label className="studios-check-label" htmlFor="studio-locations-check" >آتلیه ها</label>
						</div>
					</a>
					:<React.Fragment></React.Fragment>}
			
					<a className={'col-xs-4 filter-location-box-container '} onClick={this.handleLocationCheckBoxChange}>
						<div className={"filter-location-box "+((this.state.showLocations)? 'selected ':'')}>
							<input
							type="checkbox"
							checked={this.state.showLocations}
							onChange={this.handleLocationCheckBoxChange}
							/>
							<label className="locations-check-label" htmlFor="kadro-locations-check" >فضای باز</label>
						</div>
					</a>
				</div>		
			</div>

			{(!this.state.showStudios && this.state.showLocations)?
					<div className="row">
						<div className="col-xs-10 studio-points-box">
							<p className="text-right map-notice">
								لطفا مکان مورد نظر را با دقت انتخاب کنید.
							</p>
						</div>	
					</div>:<React.Fragment></React.Fragment>}
			{(!this.state.showStudios && !this.state.showLocations)?
					<div className="row">
						<div className="col-xs-10 studio-points-box">
							<p className="text-right  map-notice">
								نقشه را در مکان مورد نظر قرار دهید.
							</p>
						</div>
					</div>:<React.Fragment></React.Fragment>}
			{(this.state.showStudios)?<div className="row">
				<div className="col-xs-10 studio-points-box">
					<p className="text-right map-notice" >
						لطفا محدوده ای که آتلیه می خواهید را انتخاب کنید.
					</p>
					{toPersianNumber(this.state.studioPointsInRange)+" آتلیه در محدوده یافت شد. "}
				</div>	
			</div>:<React.Fragment></React.Fragment>}
		</React.Fragment>;
		let map =
			<div className='_1WR' id="map" style={{width: '100%', height: mapHeight, position: 'relative', overflow: 'hidden' , opacity: (this.state.checkStudioSelected?'0.3':'1'), pointerEvents: (this.state.checkStudioSelected?'none':'all')}}>
				{(mobileDisplay)?mapContentsInMobile:mapContentsInDesktop}
			</div>;
		return (
			<React.Fragment>
			  	{/*<div className="container">
			    	<div className="main" style={{height:this.mainHeight}}>
      					<div className="wrapper">*/}
						  	<div id="map-canvas" style={{display:'none'}}></div>
			                <div className="row" id="location-pick">
			                  <div className="col">
			                  <h3 className="text-right">
			                  {(headerNumber)+'کجا میخواهید عکاسی کنید؟'}
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
                			
  						{/*</div>*/}
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
						{(!this.state.locationIsSelected)?<div className="row full-continue-btn" style={{position: (this.footerPosition),width: (this.footerWidth),
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
				      </div>:<React.Fragment></React.Fragment>}
				     {/* <br />
					</div>
				</div>
				<BookFooter
					backButtonDisabled={false}
					previousStep={this.props.previousStep}
					handleSubmitButton={this.handleSubmitButton}
					continueButtonDisabled={( !this.state.isMapSelected)}
					wait={this.state.wait}
					payment={false}
				/>*/}
				{(this.state.locationIsSelected)?
					<ReceiveTypeTabV2
                        mediumImageLink={this.state.mediumImageLink}
                        shoot_type_selected_id={this.state.shoot_type_selected_id}
                        token={this.props.token}
                        project_slug={this.props.project_slug}
                        selectedServicePackageIdCallBack={this.props.selectedServicePackageIdCallBack}
                        isServiceSelected_callBack1={this.props.isServiceSelected_callBack1}
                        inLocationPackages={this.state.inLocationPackages}
                        notInLocationPackages={this.state.notInLocationPackages}
                        receiveType={this.state.receiveType}
                        servicePackageSelectedData_callBack={this.props.servicePackageSelectedData_callBack}
                        link={this.props.link}
                        wait={this.state.wait}
						handleSubmitButtonCallBack={this.props.handleSubmitButtonCallBack}
						handleDirectSubmitButtonCallBack={this.props.handleDirectSubmitButtonCallBack}
                        recommendationGalleryIndex={this.state.recommendationGalleryIndex}
                        recommendationMemoryIndex={this.state.recommendationMemoryIndex}
                        direct={this.props.direct}
                        directInfoReceived={this.state.directInfoReceived}
                        step={this.props.step}
                        locationWasSelected={this.props.locationWasSelected}
                        locationIsSelected={this.state.locationIsSelected}
		                shootTypeSelectedTitle={this.state.shootTypeSelectedTitle}
		                shootTypeSelectedExtendedHourCost={this.state.shootTypeSelectedExtendedHourCost}
                       />:<React.Fragment></React.Fragment>}
				<WaitingPopup wait={this.state.wait}/>
				<AddressDetailsPopup
				value={this.state.addressDetail}
				show={this.state.addressDetailsPopupShow}
				addressDetailInitCallBack={(val)=>{this.setState({addressDetail: val})}}
				submitButtonCallBack={()=>this.addressDetailPopupSubmitButtonClicked()}/>
			</React.Fragment>
		);
	}
}
