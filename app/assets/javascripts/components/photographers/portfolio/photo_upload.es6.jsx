	class PhotoUpload extends React.Component {
	constructor(props) {
		super();
		this.state = {
			
			shootTypes:[],
			shootUploadItems:[],
			shootPhotoItemsMap:[],////Maps Shoot Types Ids to relevant Photo Divs
			expertiseIds:[],////Maps Shoot Types Ids to relevant expertise Ids
			uploadingsStatus:[],///Maps  Shoot Types Ids to relevant uploading status
			loadedData:false,
			readRuleCheckBox:false,
			modalSubmitted:false,
			onGoingPhotoUploadEvent:{},
		};
		this.loadedShootPhotoItemsMap=[];
		this.loadedShootUploadItems=[];
		this.loadedExpertiseIds=[];
		this.handleClickShootType=this.handleClickShootType.bind(this);
		this.getShootTypeById=this.getShootTypeById.bind(this);
		this.checkIdAvailable=this.checkIdAvailable.bind(this);
		this.deleteDivItemsById=this.deleteDivItemsById.bind(this);
		this.uploadFile=this.uploadFile.bind(this);
		this.callPhotoUploadApi=this.callPhotoUploadApi.bind(this);
		this.readFile=this.readFile.bind(this);
		this.getExpertiseId=this.getExpertiseId.bind(this);
		this.deleteExpertiseId=this.deleteExpertiseId.bind(this);
		this.callDeleteExpertiseApi=this.callDeleteExpertiseApi.bind(this);
		this.callDeletePhotoApi=this.callDeletePhotoApi.bind(this);
		this.handleClickDeleteExpertise=this.handleClickDeleteExpertise.bind(this);
		this.checkUploadingIsTrueById=this.checkUploadingIsTrueById.bind(this);
		this.setUploadingStatusById=this.setUploadingStatusById.bind(this);
		this.addPhotoDivByShootTypeId=this.addPhotoDivByShootTypeId.bind(this);
		this.loadPhotoDivByShootTypeId=this.loadPhotoDivByShootTypeId.bind(this);
		this.handleClickDeletePhoto=this.handleClickDeletePhoto.bind(this);
		this.updatePhotoDivItemMapById=this.updatePhotoDivItemMapById.bind(this);
		this.updateLoadedPhotoDivItemMapById=this.updateLoadedPhotoDivItemMapById.bind(this);
		this.renderPhotoDivItemsById=this.renderPhotoDivItemsById.bind(this);
		this.callReadNextFile=this.callReadNextFile.bind(this);
		this.setProgressById=this.setProgressById.bind(this);
		this.handleClickUpload = this.handleClickUpload.bind(this);
		this.handleModalSubmitted =this.handleModalSubmitted.bind(this);
	}
	componentDidMount(){
	}
	componentDidUpdate(){
		
		if(this.props.loadData && !this.state.loadedData && $('#business li').length == this.props.shootTypesLength && this.props.signedExpertises.length>0 )
		{
			for (var i = 0; i < this.props.signedExpertises.length; i++) 
        	{
        		
				let selector="#"+this.props.signedExpertises[i].shoot_type_id+".specialty";
				
				$(selector).addClass('selected');

				//add new shoot upload Div
				
        	}
			this.setState({loadedData:true});
		}
		
	}
	componentWillReceiveProps(nextProps){
		if(nextProps.shootTypes!==this.props.shootTypes)
        {
            this.setState({shootTypes:nextProps.shootTypes});
            if(this.props.loadData && this.props.signedExpertises.length>0 && !this.state.loadedData)
			{
				for (var i = 0; i < this.props.signedExpertises.length; i++) 
	        	{
	        		let shootType={};
	        		nextProps.shootTypes
					.map((object) =>{
						if(this.props.signedExpertises[i].shoot_type_id==object.id)
						{	
							
							shootType=object;
						}
					});


					//add new shoot upload Div
					let shootUploadItem={
						id:shootType.id,
						title:shootType.title,
						progress:0
					}
					//console.log("before adding shoot type without photo:");
					//console.log(this.state.shootUploadItems);
					this.loadedShootUploadItems.push(shootUploadItem);
					let newExpertiseId={shootTypeId:shootType.id,expertiseId:this.props.signedExpertises[i].id}
					this.loadedExpertiseIds.push(newExpertiseId);

					

					for (var j = 0; j < this.props.signedExpertises[i].photos.length; j++) 
					{
						
						let thisPhoto=this.props.signedExpertises[i].photos[j];
						thisPhoto.name=baseName(thisPhoto.name);
						let photo={
				            	size:thisPhoto.size,
								id:thisPhoto.id,
								thumb_url:thisPhoto.thumb_url,
								medium_url:thisPhoto.medium_url,
								name:thisPhoto.name,
							}
						this.loadPhotoDivByShootTypeId(shootType.id,photo);
						
					}
	        	}

				this.setState({shootPhotoItemsMap:this.loadedShootPhotoItemsMap});
				this.setState({shootUploadItems:this.loadedShootUploadItems});
				this.setState({expertiseIds:this.loadedExpertiseIds});
			}
            
            
            
		}
	}
	loadPhotoDivByShootTypeId(shootTypeId,photo){
		//console.log("addPhotoDivByShootTypeId photo: ");
		//console.log(photo);
		let photoSize=readable_size(photo.size)
		let photoDiv=<tr className="template-download" id={photo.id} shoottypeid={shootTypeId}>
						<td className="preview">
							<a href={this.props.link+photo.medium_url} target="_blank">
								<img rel="gallery" src={this.props.link+photo.thumb_url} alt={photo.name} style={{width:'110px'}} />
							</a>
						</td>
						<td className='name'>{photo.name}</td>
						<td className="size">
							<span>
								{photoSize}
							</span>
						</td>
						<td colSpan="2"></td>
						<td className="delete"> 
							<a className="btn btn-xs text-danger delete_photo" data-remote="true" rel="nofollow" onClick={this.handleClickDeletePhoto} >
								<img  alt="حذف رشته انتخابی" width="10px" src="/img/close.png" />
								حذف عکس
							</a>
						</td>
					</tr>          
					;
			
		this.updateLoadedPhotoDivItemMapById(shootTypeId,photo.id,photoDiv);
		
	}
	updateLoadedPhotoDivItemMapById(shootTypeId,photoId,photoDiv){
		let index=-1;
		for (var i = this.loadedShootPhotoItemsMap.length - 1; i >= 0; i--)
		{
			if(this.loadedShootPhotoItemsMap[i].shootTypeId==shootTypeId)
			{
				index=i;
				let photoItem={id:photoId,div:photoDiv}
				this.loadedShootPhotoItemsMap[i].photoItems.push( photoItem );			
			}
		}
		if(index==-1)
		{
			//new shootUploadPhotoItems
			let photoItem={id:photoId,div:photoDiv}
			let photoItems=[];
			photoItems.push(photoItem);
			let shootUploadPhotoItem={shootTypeId:shootTypeId,photoItems:photoItems};

			this.loadedShootPhotoItemsMap.push( shootUploadPhotoItem );
			
			
		}
	}
	callDeletePhotoApi(id){
		//console.log("callDeletePhotoApi: id:"+id);
		let url=this.props.link+'/api/v1/photos/'+id;			
		return fetch(url, {method:'delete',
        headers: {"Authorization":this.props.token}
        }).then((response)=>{
            	
		})
        .catch(function(e){console.log(e)});
	}
	callDeleteExpertiseApi(id){
		let url=this.props.link+'/api/v1/expertises/'+id;					
		return fetch(url, {method:'delete',
        headers: {"Authorization":this.props.token}
        }).then((response)=>{
            	
			})
            .catch(function(e){console.log(e)});
	}
	handleClickDeleteExpertise(event){
		let targetId=event.currentTarget.id;
		let selector="#"+targetId+".specialty";
		
		if(this.checkUploadingIsTrueById(targetId))/////need to be checked!!!!!!!!!!!!!!!!!!
			return;

		let expertiseId=this.getExpertiseId(targetId);

		
		if(expertiseId!=-1)
		{
			let result = confirm("آیا می‌ خواهید رشته ی مورد نظر را حذف کنید؟");
			if (result) {
				$(selector).removeClass('selected');
				this.deleteDivItemsById(targetId);
				this.deleteExpertiseId(targetId);
				this.callDeleteExpertiseApi(expertiseId);
			}
		}
		else{
			$(selector).removeClass('selected');
			this.deleteDivItemsById(targetId);
			this.deleteExpertiseId(targetId);

		}
		
		
		
		
	}
	deleteDivItemsById(id){
		let shootUploadItemsArray = [...this.state.shootUploadItems]; 
		let shootPhotoItemsMapArray = [...this.state.shootPhotoItemsMap]; 

		for (var i = this.state.shootUploadItems.length - 1; i >= 0; i--) {
			if(this.state.shootUploadItems[i].id==id)
			{
				
				shootUploadItemsArray.splice(i, 1);

			}
		}
		for (var i = this.state.shootPhotoItemsMap.length - 1; i >= 0; i--) {
			if(this.state.shootPhotoItemsMap[i].shootTypeId==id)
			{
				
				shootPhotoItemsMapArray.splice(i, 1);
			}
		}
		this.setState({shootUploadItems:shootUploadItemsArray});
		this.setState({shootPhotoItemsMap:shootPhotoItemsMapArray});
		
	}
	deleteExpertiseId(shootTypeId){
		let expertiseIdsArray = [...this.state.expertiseIds]; 
		let index=-1 ;
		this.state.expertiseIds
			.map((object,i) =>{
				if(parseInt(shootTypeId)==parseInt(object.shootTypeId))
				{	
					index=i;
				}
			});
		if(index!=-1)
		{	

			expertiseIdsArray.splice(index, 1);
			this.setState({expertiseIds: expertiseIdsArray});
		}
	}
	
	checkIdAvailable(id){
		let result = false;
		$(".table.table-hover .files").each((i, element)=>{
			if(id==element.parentNode.id)
			{
				result=true;
			}
		});
		return result;
	}
	getExpertiseId(shootTypeId){
		let expertiseId=-1;
		this.state.expertiseIds
			.map((object,i) =>{
				if(parseInt(shootTypeId)==parseInt(object.shootTypeId))
				{	
					expertiseId=object.expertiseId;
				}
			});
		return expertiseId;
	}
	getShootTypeById(id){
		let resultShootType={};
		this.state.shootTypes
			.map((object) =>{
				if(id==object.id)
				{	
					
					resultShootType=object;
				}
			});
		return resultShootType;
	}
	checkUploadingIsTrueById(id){
		let resultStatus;
		this.state.uploadingsStatus
			.map((object) =>{
				if(id==object.id)
				{
					resultStatus=object.status;
				}
			});
		return resultStatus;
	}
	setUploadingStatusById(status,id){
		let findedId=-1;
		this.state.uploadingsStatus
			.map((object) =>{
				if(id==object.id)
				{	
					findedId=object.id;
					object.status=status;
				}
			});

		if(findedId==-1)
		{
			let updateStatus={id:id,status:status}
			this.setState({uploadingsStatus:[...this.state.uploadingsStatus,updateStatus]});
		}
	}
	handleClickDeletePhoto(event){
		let thisPhotoId=event.currentTarget.parentNode.parentNode.id;
		let thisShootTypeId=event.currentTarget.parentNode.parentNode.getAttribute('shoottypeid');
		this.callDeletePhotoApi(thisPhotoId);

		let shootPhotoItemsArray = [...this.state.shootPhotoItemsMap];
		for (var i = this.state.shootPhotoItemsMap.length - 1; i >= 0; i--) {
			if(this.state.shootPhotoItemsMap[i].shootTypeId==thisShootTypeId)
			{

				for (var j = this.state.shootPhotoItemsMap[i].photoItems.length - 1; j >= 0; j--) {
					if(this.state.shootPhotoItemsMap[i].photoItems[j].id==thisPhotoId)
					{
						let shootPhotoItemArray = this.state.shootPhotoItemsMap[i];
						let photoItemsArray = [...this.state.shootPhotoItemsMap[i].photoItems];

						photoItemsArray.splice( j,1 );
						shootPhotoItemArray.photoItems=photoItemsArray;
						shootPhotoItemArray.shootTypeId=thisShootTypeId;


						shootPhotoItemsArray[i]=shootPhotoItemArray;

						this.setState({shootPhotoItemsMap:shootPhotoItemsArray},()=>{
						});
					}
				}
			}
		}
		//event.currentTarget.parentNode.parentNode.remove();
	}
	updatePhotoDivItemMapById(shootTypeId,photoId,photoDiv){
		//console.log("updatePhotoDivItemMapById ");
		//console.log("before adding shootPhotoItemsMap:");
		//console.log(this.state.shootPhotoItemsMap);
		let index=-1;
		let shootPhotoItemsArray = [...this.state.shootPhotoItemsMap];
		for (var i = this.state.shootPhotoItemsMap.length - 1; i >= 0; i--)
		{
			//console.log("updatePhotoDivItemMapById before adding shootPhotoItemsMap[i]:");
			//console.log(this.state.shootPhotoItemsMap[i]);
			//console.log(this.state.shootPhotoItemsMap[i].shootTypeId+"=="+shootTypeId);
			if(this.state.shootPhotoItemsMap[i].shootTypeId==shootTypeId)
			{
				//add shootUploadItem and update shootUploadItemsMap
				index=i;
				//console.log( "founded shoot type id :" +shootTypeId );
				let photoItem={id:photoId,div:photoDiv}
				let shootPhotoItemArray={};
				shootPhotoItemArray = this.state.shootPhotoItemsMap[i];
				let photoItemsArray = [...this.state.shootPhotoItemsMap[i].photoItems];
////////////////////////////////////////////////////////////////////////////////////				
				//console.log("updatePhotoDivItemMapById before adding photoItemsArray:");
				//console.log(photoItemsArray);

				photoItemsArray.push( photoItem );

				//console.log("updatePhotoDivItemMapById after adding photoItemsArray:");
				//console.log(photoItemsArray);
//////////////////////////////////////////////////////
				//console.log("updatePhotoDivItemMapById before adding shootPhotoItemArray:");
				//console.log(shootPhotoItemArray);

				shootPhotoItemArray.photoItems=photoItemsArray;
				shootPhotoItemArray.shootTypeId=shootTypeId;

				//console.log("updatePhotoDivItemMapById after adding shootPhotoItemArray:");
				//console.log(shootPhotoItemArray);
///////////////////////////////////////////////////////////////////
				//console.log("updatePhotoDivItemMapById before adding shootPhotoItemsMap[i]:");
				//console.log(shootPhotoItemsArray[i]);

				shootPhotoItemsArray[i]=shootPhotoItemArray;

				//console.log("updatePhotoDivItemMapById after adding shootPhotoItemsMap[i]:");
				//console.log(shootPhotoItemsArray[i]);

				this.setState({shootPhotoItemsMap:shootPhotoItemsArray},()=>{
					//console.log("updatePhotoDivItemMapById after adding shootPhotoItemsMap:");
					//console.log(this.state.shootPhotoItemsMap);
				});
				
			}
		}
		if(index==-1)
		{
			//new shootUploadPhotoItems
			let photoItem={id:photoId,div:photoDiv}
			let photoItems=[];
			photoItems.push(photoItem);
			let shootUploadPhotoItem={shootTypeId:shootTypeId,photoItems:photoItems};
			//console.log("updatePhotoDivItemMapById new photo before adding shootPhotoItemsMap:");
			//console.log(this.state.shootPhotoItemsMap);
			let shootPhotoItemsArray = [...this.state.shootPhotoItemsMap];

			shootPhotoItemsArray.push( shootUploadPhotoItem );
			this.setState({shootPhotoItemsMap:shootPhotoItemsArray},()=>{
				//console.log("updatePhotoDivItemMapById after adding shootPhotoItemsMap:");
				//console.log(this.state.shootPhotoItemsMap);
			});
			
			
		}
	}
	addPhotoDivByShootTypeId(shootTypeId,photo){
		//console.log("addPhotoDivByShootTypeId photo: ");
		//console.log(photo);
		let photoSize=readable_size(photo.size)
		let photoDiv=<tr className="template-download" id={photo.id} shoottypeid={shootTypeId}>
						<td className="preview">
							<a href={this.props.link+photo.medium_url} target="_blank">
								<img rel="gallery" src={this.props.link+photo.thumb_url} alt={photo.name} style={{width:'110px'}} />
							</a>
						</td>
						<td className='name'>{photo.name}</td>
						<td className="size">
							<span>
								{photoSize}
							</span>
						</td>
						<td colSpan="2"></td>
						<td className="delete"> 
							<a className="btn btn-xs text-danger delete_photo" data-remote="true" rel="nofollow" onClick={this.handleClickDeletePhoto} >
								<img  alt="حذف رشته انتخابی" width="10px" src="/img/close.png" />
								حذف عکس
							</a>
						</td>
					</tr>          
					;
			
		this.updatePhotoDivItemMapById(shootTypeId,photo.id,photoDiv);
		
	}
	handleModalSubmitted(){
		
		let inputFileElement = document.getElementById('file-input '+this.state.clickedUploadId);
		let evt = document.createEvent("MouseEvents");
		evt.initEvent("click", true, false);
		inputFileElement.dispatchEvent(evt);
		$("#modalPhotoNotes").modal("hide");
	}
	handleClickUpload(event){
		
		$('#modalPhotoNotes').modal("show");
		this.setState({clickedUploadId:event.target.id});
		
	}
	uploadFile(event){

		//uploadFile();
		// for unabling to click delete expertise button
		
		let acceptFileTypes = /^image\/(jpe?g|png)$/i;
		let files = event.target.files;
		let shootTypeId = event.target.getAttribute("data-id");;
		
 		let i=0;
        let file = files[i]; 
		file.shootTypeId=shootTypeId;
		file.acceptFileTypes=acceptFileTypes;
		//console.log("preparing next readFile....:"+i);
		//console.log(files);
		//console.log("preparing next file....:(check file.shootTypeId)");
		//console.log(file);
		this.setUploadingStatusById(true,event.target.getAttribute("data-id"));
		this.readFile(files,file,i);
		// for enabling to click delete expertise button
		
	}
	callReadNextFile(files,file,i)
	{
		let nextIndex=i+1;
        if(nextIndex<files.length){
        	let nextFile = files[nextIndex]; 
       
			nextFile.shootTypeId=file.shootTypeId;
			nextFile.acceptFileTypes=file.acceptFileTypes;
			
        	this.readFile(files,nextFile,nextIndex);
        }
        else{
        	this.setUploadingStatusById(false,file.shootTypeId);
        	$('input[name=file1]').val(null);
			//console.log("uploading finished..."+file.shootTypeId);
        }
	}
	readFile(files,file,i){
		//console.log("readFile.... this file:(check file.shootTypeId)");
    	//console.log(file);
		let fr= new FileReader(); 
		let image= new Image();
    	let imageDiv="";
    	let havePhotoErrors=false;
    	file.uploadErrors = [];

		if(!file.acceptFileTypes.test(file.type))
		{

			file.uploadErrors.push('تایپ فایل درست نیست.');

		}

		if( file.size > 5000000) 
		{

			file.uploadErrors.push('حجم فایل نباید بیش از ۵ مگابایت باشد.');
        }
        if(file.uploadErrors.length == 0)
		{

			fr.addEventListener("load",(frEvent)=>{
				image.uploadErrors = [];
				
				image.addEventListener("load",()=>{
					
					if( image.width > 6000 ) {
						
						image.uploadErrors.push('عرض عکس رعایت نشده است: '+image.width+'px');						
					}
					if( image.height > 6000  ) {

						
						image.uploadErrors.push('طول عکس رعایت نشده است: '+image.height+'px');

					} 
			
					if(image.uploadErrors.length > 0 ) 
					{		

			        	alert(image.uploadErrors.join("\n"));
			        	
                        this.callReadNextFile(files,file,i)
					}
					else
					{
						//filesSelector.append(imageDiv);
						
						this.callPhotoUploadApi(files,file,i);
						
					}
						
				
				});
				image.src = frEvent.target.result;
			 
	      
    		});
		}	
			
		
    	
    	fr.readAsDataURL(file); 
    	if(file.uploadErrors.length > 0)
		{
			alert(file.uploadErrors.join("\n"));

		}
			
	}
	setProgressById(shootUploadId,progress){
		let shootUploadItemsArray = [...this.state.shootUploadItems];
		for (var i = this.state.shootUploadItems.length - 1; i >= 0; i--) {
			if(this.state.shootUploadItems[i].id==shootUploadId)
			{
				
				let shootUploadItem=this.state.shootUploadItems[i];
				shootUploadItem.progress=progress;
				//this.state.shootUploadItems[i].progress=progress;
				shootUploadItemsArray[i]=shootUploadItem;
				this.setState({shootUploadItems:shootUploadItemsArray});
			}
		}
	}
	callPhotoUploadApi(files,file,i){
		//console.log("readFile.... this file:(check file.shootTypeId)");
    	//console.log(file);
		let filesSelector = $("#"+file.shootTypeId+".table.table-hover .files");
		let formData = new FormData();
		let shootTypeId = file['shootTypeId'];
		formData.append('file', file);
		formData.append('shoot_type_id', shootTypeId);
		formData.append('photographer_id', this.props.photographerId);
		let expertiseId=this.getExpertiseId(file['shootTypeId']);
		//console.log("finded or not:"+expertiseId);
		if(expertiseId!=-1)
		{	
			//console.log("finded:"+expertiseId);
			formData.append('expertise_id', expertiseId);
		}
		
        let url=this.props.link+'/api/v1/photos';
        
        return $.ajax({
                    url: url,
                    headers: {"Authorization":this.props.token},
                    data: formData,
                    processData: false,
                    contentType: false,
                    type: 'POST',
                    // this part is progress bar
                    xhr: ()=> {
						{/*$('div#'+shootTypeId+' > div.row  > div.progress').removeClass(
						'fade'
						);*/}
                        var xhr = new window.XMLHttpRequest();
                        var started_at = new Date();

                        xhr.upload.addEventListener("progress",  (evt) =>{


                            if (evt.lengthComputable) {

                                var progress = Math.round((evt.loaded/evt.total)*100);
                               
                                {/*$('div#'+shootTypeId+' > div.row  > div.progress  > div.progress-bar.progress-bar-success.progress-bar-striped').css(
					                'width',
					                progress + '%'
					            );*/}
					            
                                this.setProgressById(shootTypeId,progress);

                                var seconds_elapsed =   ( new Date().getTime() - started_at.getTime() )/1000;
                                
                                var hours   = Math.floor(seconds_elapsed / 3600);
							    var minutes = Math.floor((seconds_elapsed - (hours * 3600)) / 60);
							    var seconds = Math.round(seconds_elapsed - (hours * 3600) - (minutes * 60));

							    if (hours  < 10) {hours  = "0"+hours;}
							    if (minutes < 10) {minutes = "0"+minutes;}
							    if (seconds < 10) {seconds = "0"+seconds;}
							    
				                var bytes_per_second =  seconds_elapsed ? evt.loaded / seconds_elapsed : 0 ;
				                
				                var Mbytes_per_second = bytes_per_second / 1000000 ;
				                $('div#'+shootTypeId+' > div.row  > div.progress-extended').html(Math.round(Mbytes_per_second*100)/100+" Mbits/s | "+hours+':'+minutes+':'+seconds+" | "+progress + ' %'+" | "+Math.round((evt.loaded/ 1000000)*1000)/1000 +" MB / "+Math.round((evt.total/ 1000000)*1000)/1000+" MB");
				          
                            }
                        }, false);
                        return xhr;
                    },
                    success: (response)=> {
                    	//console.log("success api data:")
                    	//add expertise id to the shoottype expertise map
                    	if(this.getExpertiseId(file['shootTypeId'])== -1)// if we have no expertise id with this shoot type id
						{
							//console.log("we have no expertise id with shoot type id:"+file['shootTypeId']);
							let newExpertiseId={shootTypeId:file['shootTypeId'],expertiseId:response.data.expertise_id}
							this.setState({expertiseIds:[...this.state.expertiseIds,newExpertiseId]});
						}

						//progress bar reset
                        {/*$('div#'+shootTypeId+' > div.row  > div.progress  > div.progress-bar.progress-bar-success.progress-bar-striped').css(
                		'width',
                		0 + '%'
            			);*/}
 						this.setProgressById(shootTypeId,0);
						{/*$('div#'+shootTypeId+' > div.row  > div.progress').addClass('fade');*/}
			            $('div#'+shootTypeId+" > div.row  > div.progress-extended").html("");
			            
			            ///add image div row

			            let photo={
			            	size:file.size,
							id:response.data.id,
							thumb_url:response.data.thumb_url,
							medium_url:response.data.thumb_url,
							name:file.name,
						}
			            this.addPhotoDivByShootTypeId(shootTypeId,photo);
			            
                        //filesSelector.append(imageDiv);

                        ///activate delete button when the first picture is uploading (dynamic adding upload photo div problem)
                        //this.activateDeletePhotoButton();
                        
                        this.callReadNextFile(files,file,i);

                    }
                });
        
	
	}
	handleClickShootType(event){
		let shootType={};
		let selector="#"+event.currentTarget.getAttribute('id')+".specialty";
		shootType=this.getShootTypeById(event.currentTarget.getAttribute('id'));
		///check if shoot type id has been clicked ago
		if(!this.checkIdAvailable(shootType.id))
		{
			$(selector).addClass('selected');

			//add new shoot upload Div
			let shootUploadItem={
				id:shootType.id,
				title:shootType.title,
				progress:0
			}
			//console.log("before adding shoot type without photo:");
			//console.log(this.state.shootUploadItems);
			this.setState({
			shootUploadItems: [...this.state.shootUploadItems, shootUploadItem]
			},()=>{
				//console.log("handleClickShootType after adding shoot type without photo:");
				//console.log(this.state.shootUploadItems);
				///scroll to fileupload div
				var target = $('#'+shootType.id+".fileupload");
				scrollToId(target);
			});
			                
			
			

			
		}
		else{
			

			if(this.checkUploadingIsTrueById(shootType.id))
				return;
			let expertiseId=this.getExpertiseId(shootType.id);
			//check if we have expertise id with that shoot type id
			if(expertiseId!=-1)
			{
				let result = confirm("آیا می‌ خواهید رشته ی مورد نظر را حذف کنید؟");
				if (result) {
					$(selector).removeClass('selected');

					this.deleteDivItemsById(shootType.id);
					this.deleteExpertiseId(shootType.id);
					this.callDeleteExpertiseApi(expertiseId);
				}
			}
			else{
				$(selector).removeClass('selected');

				this.deleteDivItemsById(shootType.id);
				this.deleteExpertiseId(shootType.id);

			}

		}
		
		
	}
	renderPhotoDivItemsById(id){
		let shootPhotoDivs=[]; 
		//console.log("rendering photoItems...");
		if(this.state.shootPhotoItemsMap.length !==0)
		{

			for (var i = 0; i < this.state.shootPhotoItemsMap.length; i++) {
				if(this.state.shootPhotoItemsMap[i].shootTypeId==id)
				{
					for (var j =0; j<this.state.shootPhotoItemsMap[i].photoItems.length ; j++) {
						//console.log("pushing....after push:");
						shootPhotoDivs.push(this.state.shootPhotoItemsMap[i].photoItems[j].div);

    					//console.log(shootPhotoDivs);
					}
				}
				
			}
    	}
    	//console.log("result photoItems:");
    	//console.log(shootPhotoDivs);
    	return shootPhotoDivs;
	}
	render () {
		let shootUploadDivItems=[]; 
		let progressDiv;
		if(this.state.shootUploadItems.length !==0)
		{
			shootUploadDivItems=this.state.shootUploadItems
			.map((object,i) =>
	    	{
	    		//console.log("rendering shootUploadItems... shootUploadItem:");
	    		//console.log(object);
	    		let shootPhotoDivs=this.renderPhotoDivItemsById(object.id);
	    		//console.log("rendering ... shootPhotoDivs:");
	    		//console.log(shootPhotoDivs);
	    		//let photoInputChanged = this.onRunClick.bind(this, object.id);
				if(object.progress>0){
	    			//console.log("progressing:");
	    			//console.log("object.progress:"+object.progress);
	    			progressDiv=
	    			<div className="progress span5" key={i}>
						 <div className="progress-bar progress-bar-success progress-bar-striped " role="progressbar"  aria-valuemin="0" aria-valuemax="100" style={{width:(object.progress)+'%'}}> </div>
		    
					</div>;
	    		}
	    		else if(object.progress==0){
	    			//console.log("progress finished or no progress:");
	    			//console.log("object.progress:"+object.progress);
	    			progressDiv=
	    			<div className="progress span5 fade" key={i}>
						 <div className="progress-bar progress-bar-success progress-bar-striped " role="progressbar"  aria-valuemin="0" aria-valuemax="100" style={{width:(object.progress)+'%'}}> </div>
		    
					</div>;
	    		}
	    		//console.log("rendering shootUploadItems... progressDiv:");
	    		//console.log(progressDiv);
				return(
					<div id={object.id} className="col-sm-12 fileupload" key={object.id}>
						<div className="row fileupload-buttonbar">
							<div style={{lineHeight: '30px'}}>
								<h2>{object.title}
								<a className="btn btn-xs text-danger " data-remote="true" onClick={this.handleClickDeleteExpertise} id={object.id}>
					                <img title="delete" src="/img/close.png" width="10px" />
					                {" حذف رشته "+
					                (object.title)}
								</a>
								</h2>
								<p>
								<span style={{color:'red'}}>
								*
								</span>
								عرض هر عکس باید کمتر از ۶.۰۰۰ پیکسل باشد.
								</p>
								<p>
								<span style={{color:'red'}}>
								*
								</span>
								طول هر عکس باید کمتر از ۶.۰۰۰ پیکسل باشد.
								</p>
								<p style={{fontStyle: 'italic'}}>
								<span style={{color:'red'}}>
								*
								</span>
								همه‌ی عکس ها
								<strong style={{textDecoration: 'underline'}}>
								{' بدون واترمارک '}
								</strong>
								باشد.
								</p>	
								<p style={{fontStyle: 'italic'}}>
								<span style={{color:'red'}}>
								*
								</span>
								باید حداقل ۶ نمونه کار
								یا بیشتر
								آپلود کنید.
								</p>
							</div>
							<div style={{overflowX:'auto'}}>
								<table role="presentation" className="table table-hover" id={object.id}>
									<tbody className="files">
										{shootPhotoDivs}
									</tbody>
							 	 </table>
					 	 	</div>
							{progressDiv}
							<div className="progress-extended" style={{direction: "ltr"}}>&nbsp;</div>
							<span id={object.id} className="btn fileinput-button btn-blue" style={{padding: '25px 25px', background: 'black'}} onClick={this.handleClickUpload} >
								<i className="icon-plus icon-white"></i>
								<span id={object.id}>
								{"انتخاب نمونه کار "+(object.title)}
								</span>
								
							</span>
							<form id={"upload_form "+object.id} enctype="multipart/form-data" method="post">
								<input type="file" name="file1" data-id={object.id} id={"file-input "+object.id} multiple onChange={this.uploadFile} style={{display: "none"}} />
							</form>	
						</div>
					</div>
				);
			});
		}
		
		let shootItems=[]; 
		if(this.state.shootTypes.length !==0)
		{

			shootItems=this.state.shootTypes
			.map((object,i) =>
	    	{

					return(
						<li className="col-xs-4 col-sm-4 col-md-4" key={i}>
							<div href="#" className="specialty "  onClick={this.handleClickShootType} id={object.id}>
								<img src={object.avatar.url} alt="" />
								<span  id={object.id}>
								{object.title}
								</span>
							</div>
						</li>
					);
			});
		}
		return (
			<React.Fragment>
				<div id="photo-upload" className="row" style={{marginBottom: '30px',display: (this.props.step=="photo"?'':'none')}}>
					<div className="col-sm-6">
						<h3>
						رشته های عکاسی
						</h3>
						<h5 style={{lineHeight: '22px'}}>
						لطفا همه رشته هایی عکاسی ای که دوست دارید سفارش عکاسی دریافت کنید را انتخاب کنید.
						انتخاب هر چه بیشتر رشته ها منجر به پروژه های عکاسی بیشتری برای شما خواهد شد.
						</h5>

						<div className="wrapper " id="detail">
							<div id="specialities" className="specialties">
								<ul id="business" className="row row-m10">
									
									{shootItems}
											
								</ul>
							</div>
						</div>
					</div>
					<div className="col-sm-6">
						<div className="alert alert-danger" id="photoCheckError" style={{ display: "none"}}>
							<ul ></ul>
						</div>
						<div id="forms_holder">
							{shootUploadDivItems}
						</div>
					</div>
				</div>
				<RulesPopUp 
					submitCallBack={this.handleModalSubmitted}
				/>
			</React.Fragment>
		);
	
	}
}