class Photographers extends React.Component {
	constructor() {
			super();
			this.state = {
				isPhotographerSelected:false,
				photographerSelectedId:-1,
				availablePhotographers:[],
				photographerSamplePhotos: [],
				photogrpaherStudioPhotos:[],
				photographerSelectedCompleteFirstName:'',
				photographerSelectedFirstName:'',
				photographerSelectedLastName:'',
				photographerSelectedAvatar:'',
				photographerSelectedTransportationCost:0,
				photographerAttachId:-1,
				displaySamplePhotos:false,
				displayStudioPhotos:false,
				photographerSelectedItemId:-1,
				waitForContinue:false,
				waitForSamplePhotos:false,
                waitForComments:false,
                comments:[],
                commentsPhotographerFirstName:'',
				commentsPhotographerLastName:'',
				startIndex:0,
			};
			this.handleSubmitButton=this.handleSubmitButton.bind(this);
			this.handleClickShowSamplePhotos=this.handleClickShowSamplePhotos.bind(this);
			this.handleClickShowStudioPhotos=this.handleClickShowStudioPhotos.bind(this);
			this.handleClickShowAttachmentPhotos=this.handleClickShowAttachmentPhotos.bind(this);
			this.handlePhotographerSelected=this.handlePhotographerSelected.bind(this);
			this.callSubmitPhotographer=this.callSubmitPhotographer.bind(this);
			this.pushWithoutHalfStarItems=this.pushWithoutHalfStarItems.bind(this);
			this.pushWithHalfStarItems=this.pushWithHalfStarItems.bind(this);
			this.roundHalf=this.roundHalf.bind(this);
			this.getFloatDecimals=this.getFloatDecimals.bind(this);
			this.scrollToSelectedPhotographer=false;
			this.showComments=this.showComments.bind(this);
			this.getPhotographerItemById=this.getPhotographerItemById.bind(this);
	}
	componentDidUpdate(){
		$('.sample-container').each((j,item)=>{
		    for (let i = 0; i<item.children.length; i++)
			{
				if(i<item.children.length-1)
				{
					($(item.children[i]).addClass('margin-between-thumbs'));
				}
			}
		});
		$('.shoot-slider').owlCarousel({
		  navText        : [],
		  nav            : true,
		  rtl            : true,
		  responsiveClass: true,
		  slideBy: 2,
		  autoHeight:true,
		  responsive     : {
		    0   : {
		      items : 1
		    },
		    600 : {
		      items : 2
		    },
		    1000: {
		      items : 2
		    }
		  }
		});
		let mobileDisplay =(window.innerWidth<970);

		if(this.scrollToSelectedPhotographer)
		{
			if(mobileDisplay)
			{

				$(".shoot-slider").trigger("to.owl.carousel", [this.state.photographerSelectedItemId, 0]);
			}
			else{
				let to=Math.floor(this.state.photographerSelectedItemId/2);
				$(".shoot-slider").trigger("to.owl.carousel", [to, 0]);
			}
			this.scrollToSelectedPhotographer=false;
		}

		let samplePhotosSelector =$('.sample_photos');
		let studioPhotosSelector =$('.studio_photos');
		$('.sample_photos #portfolio_fotorama').on('click',()=>{
			samplePhotosSelector.find('.close').trigger('click');
		});
		$('.studio_photos #studio_fotorama').on('click',()=>{
			studioPhotosSelector.find('.close').trigger('click');
		});
		$('.sample_photos #portfolio_fotorama .fotorama__wrap').on('click',()=>{return false;});

		$('.studio_photos #studio_fotorama .fotorama__wrap').on('click',()=>{return false;});

		$('.fotorama__fullscreen-icon').on('click',()=>{return false;});

	    samplePhotosSelector.find('.close').on('click', ()=> {
	    	if(mobileDisplay && $('.fotorama__fullscreen-icon').hasClass('mobile-exited'))
	    	{
	    		$('.fotorama__fullscreen-icon').removeClass('mobile-exited');
	    		return false;
	    	}

			$('#main').removeClass('blur');
			this.setState({displaySamplePhotos: false});

		});
		studioPhotosSelector.find('.close').on('click', ()=> {
	    	if(mobileDisplay && $('.fotorama__fullscreen-icon').hasClass('mobile-exited'))
	    	{
	    		$('.fotorama__fullscreen-icon').removeClass('mobile-exited');
	    		return false;
	    	}

			$('#main').removeClass('blur');
			this.setState({displayStudioPhotos: false});

	    });


	    jQuery(document).keyup((e)=> {
	      if (e.keyCode === 27) {
	        $('#main').removeClass('blur');
	        this.setState({photographerAttachId: -1});
			this.setState({displaySamplePhotos: false});
			this.setState({displayStudioPhotos: false});
	      }
	    });

      $('[data-toggle="transportation_cost_tooltip"]').tooltip();
	}
	componentWillReceiveProps(nextProps){
		let directAndPhotographerSelected= this.props.photographerUid!==null && this.props.photographerUid.length>0;
		$('.shoot-slider').owlCarousel('destroy');
		if(directAndPhotographerSelected && nextProps.availablePhotographers.length>0){

	    	let firstName = nextProps.availablePhotographers[0].first_name.charAt(0)+". ";
    		this.setState({photographerSelectedItemId:0});
			this.setState({photographerSelectedId:nextProps.availablePhotographers[0].id});
			this.setState({photographerSelectedCompleteFirstName:nextProps.availablePhotographers[0].first_name});
			this.setState({photographerSelectedTransportationCost:nextProps.availablePhotographers[0].price});
			this.setState({photographerSelectedFirstName:firstName});
			this.setState({photographerSelectedLastName:nextProps.availablePhotographers[0].last_name});
			this.setState({isPhotographerSelected:true});
	    }
        if(
			nextProps.dateTimeSelected !== this.props.dateTimeSelected ||
			nextProps.isMapChanged!==this.props.isMapChanged ||
			nextProps.shootTypeSelectedId!==this.props.shootTypeSelectedId ||
			nextProps.selectedServicePackageId!==this.props.selectedServicePackageId ||
			nextProps.photographerUid!==this.props.photographerUid
		 )
        {
        	if(!directAndPhotographerSelected)
			{
	        	this.setState({isPhotographerSelected:false});
	        	this.setState({photographerSelectedId:-1});
	        	this.setState({photographerSelectedItemId:-1});
				this.setState({photographerSelectedFirstName:''});
				this.setState({photographerSelectedCompleteFirstName:''});
				this.setState({photographerSelectedLastName:''});
			}
        }


        if (nextProps.step != this.props.step && nextProps.step==4) {
        	if(this.state.photographerSelectedItemId!=-1)
			{
				this.scrollToSelectedPhotographer=true;
			}
        }

    }
	handleSubmitButton(){
		this.callSubmitPhotographer();
		this.props.nextStep();
		//preparing for receipt page show photographer infos
		var data={
			firstName:this.state.photographerSelectedFirstName,
			completeFirstName:this.state.photographerSelectedCompleteFirstName,
			lastName:this.state.photographerSelectedLastName,
			avatar:this.state.photographerSelectedAvatar,
			photographerSelectedId:this.state.photographerSelectedId,
		}
		this.props.photographersFieldValues(data);
	}
	handleClickOnPhotographerMobileButton(event){

		if(mobileDisplay)
		{
			let url="tel:"+event.currentTarget.getAttribute('mobile_number');
			window.open(url, '_blank');
		}
		else
		{
			$(event.currentTarget).text(toPersianNumber(event.currentTarget.getAttribute('mobile_number')))
		}
	}
	handleClickShowAttachmentPhotos(event)
	{
		if (event.currentTarget.getAttribute('data-avatars')!=null)
		{
			$('#main').addClass('blur');
			this.setState({displayAttachmentPhotos: true});
		    this.setState({photographerAttachId:parseInt(event.currentTarget.getAttribute('data-value'))});
		}
	}
	handleClickShowStudioPhotos(event){
		let startIndex = event.currentTarget.getAttribute('start-index');
		let photographerId = parseInt(event.currentTarget.getAttribute('data-value'));
		let photographerItem= this.getPhotographerItemById(photographerId);
		this.setState({photographerStudioPhotos:photographerItem.studio_photos});
		this.setState({startIndex:startIndex})
		this.setState({displayStudioPhotos: true});

	}
	handleClickShowSamplePhotos(event){
		this.setState({waitForSamplePhotos:true});
        let photographer_photos=[];
        let startIndex = event.currentTarget.getAttribute('start-index');
		let url=this.props.link+'/api/v1/photographers_photos?photographer_id='+parseInt(event.currentTarget.getAttribute('data-value'))+"&shoot_type_id="+this.props.shootTypeSelectedId;
        fetch(url, {method:'get',
            })
            .then((response)=>{
                if (parseInt(response.status) != 202) {

                    response.json().then((object) =>{

                    });

                }
                else{
                    response.json().then((object) =>{
							this.setState({waitForSamplePhotos:false});
                            if(object.length==0)
                            {

                            }
                            else{
                                object['photos'][0].map((item) =>{


                                    photographer_photos.push(item);
                                });
                                this.setState({photographerSamplePhotos:photographer_photos});
                                this.setState({startIndex:startIndex})
                                this.setState({displaySamplePhotos: true});
                                $('#main').addClass('blur');
                            }
					});

                }



            })
            .catch(function(e){console.log(e)});

	}
	handlePhotographerSelected(event){
		let $e = $(event.currentTarget);
		if(this.state.isPhotographerSelected && $e.attr('data-selector')==this.state.photographerSelectedId)
		{
			//user has clicked the selected photographer again
			this.setState({isPhotographerSelected:false});
			this.setState({photographerSelectedId:-1});
			this.setState({photographerSelectedFirstName:''});
			this.setState({photographerSelectedCompleteFirstName:''});
			this.setState({photographerSelectedLastName:''});
		}
		else
		{

			this.setState({photographerSelectedItemId:parseInt($e.attr('item-id'))});
			this.setState({photographerSelectedId:$e.attr('data-selector')});
			this.setState({photographerSelectedCompleteFirstName:$e.attr('complete-first-name')});
			this.setState({photographerSelectedFirstName:$e.attr('first-name')});
			this.setState({photographerSelectedLastName:$e.attr('last-name')});
			this.setState({photographerSelectedAvatar:$e.attr('img-url')});
			this.setState({isPhotographerSelected:true});
		}
	}
	callSubmitPhotographer(){
		let feedbacks=[];
		let url=this.props.link+"/api/v2/submit_photographer";
		let body="photographer[id]="+this.state.photographerSelectedId+"&project_slug="+this.props.project_slug;
    	this.setState({waitForContinue:true});
		fetch(url, {method:'post',
            body: body,
            headers: { "Content-Type": "application/x-www-form-urlencoded","Accept":"application/json" ,"Authorization":this.props.token }})
            .then((response)=>{
            	if (parseInt(response.status) != 202) {
            		response.json().then((object) =>{

    				});

            	}
                else{

                	response.json().then((object) =>{
                		object['feedback'][0].map((item) =>{

            				feedbacks.push(item);
            			});
    					this.setState({waitForContinue:false});
            			this.props.feedbacks(feedbacks);
            		});

    			}



				}).catch(function(e){console.log(e)});
	}
	getFloatDecimals(float){

		// get the position of the radix-point
		let radixPos = String(float).indexOf('.');

		//use slice, on a String, to get numbers after '.'
		let value = String(float).slice(radixPos+1);
		return parseInt(value);
	}
	roundHalf(num) {
		if(this.getFloatDecimals(num)>5)
    		return Math.round(num);
    	else
    		return Math.round(num*2)/2;
	}
	pushWithoutHalfStarItems(rate){
		let items=[];
		for (i=0; i< 5-rate ; i++) {
			items.push(<span className="none-star"></span>)
		}
		for (let i=0 ; i< rate ; i++) {
			items.push(<span className="star"></span>)
		}
		return items;
	}
	pushWithHalfStarItems(rate){
		let items=[];

		//example: rate with 2.5 must have 2 stars and 5-(2)-1 empty stars and one half star
		for (i=0; i< 5-rate-1 ; i++) {
			items.push(<span className="none-star"></span>)
		}
		items.push(<span className="half-star"></span>)
		for (let i=0 ; i< rate ; i++) {
			items.push(<span className="star"></span>)
		}
		return items;
	}
	showComments(event){
		this.setState({waitForComments:true});
		let photgrapherFirstName=event.currentTarget.getAttribute('first-name');
        let photgrapherLastName=event.currentTarget.getAttribute('last-name');
        let url=this.props.link+'/api/v1/feed_backs?id='+event.currentTarget.getAttribute('uid');
        return fetch(url, {method:'get',
            headers: { "Accept":"application/json"  }})
            .then((response)=>{
            	response.json().then((object) =>{
        			this.setState({waitForComments:false});
        			this.setState({comments:object.feed_backs});
        			this.setState({commentsPhotographerFirstName:photgrapherFirstName});
					this.setState({commentsPhotographerLastName:photgrapherLastName});
        			$("#modalComments").modal();
				});
			}).catch(function(e){console.log(e)});
	}
	getPhotographerItemById(id){
		let photographerItem ={};
		this.props.availablePhotographers.forEach(item => {
			if(item.id==id)
				photographerItem = item;
		}); 
		return photographerItem;
	}
  	render () {
  		let directAndPhotographerSelected= this.props.photographerUid!==null && this.props.photographerUid.length>0;
  		let numOfNearPhotographers = 0;
		let numOfFarPhotographers = 0;

  		this.props.availablePhotographers
	    	.map((item,i) =>
	    	{
	    		if(item.price == '0')
	    		{
	    			numOfNearPhotographers++;
	    		}
	    		else
	    		{
	    			numOfFarPhotographers++;
	    		}
	    	}
	   );

		let allPhotographersAttachments = this.props.availablePhotographers.map((photographerItem,i)=>
		{

			if(photographerItem.attachments!=null){
				return(
					<div style={{display: (photographerItem.id==this.state.photographerAttachId)?'block':'none'}} key={i}>
						<PhotographerAttachments
							photos={photographerItem.attachments}
							photographerId={photographerItem.id}
							closeCallBack={()=> this.setState({photographerAttachId: -1})}
						/>
					</div>
				);
			}
			else{
				return(
					<div key={i}></div>
				);
			}

		});

	  	let availablePhotographerItems= this.props.availablePhotographers
		    	.map((item,i) =>
		    	{
		    		let specialIcon = (i==0)?<div> <i className="fa fa-check"></i> {"پیشنهاد  ما"} </div>:<React.Fragment></React.Fragment>;
		    		let rate = item.rate;
		    		let starItems = [];
		    		if(Number.isInteger(rate))
		    		{
		    			starItems= this.pushWithoutHalfStarItems(rate);
		    		}
		    		else
		    		{
		    			let new_rate = this.roundHalf(rate);
		    			if(Number.isInteger(new_rate))
						{
							starItems=this.pushWithoutHalfStarItems(new_rate);
						}
						else
						{
							//rate with 2.5 must have 2 stars 1 half star and 2 empty stars
							let starItemCount=Math.floor(new_rate);
							starItems=this.pushWithHalfStarItems(starItemCount);
						}
		    		}
		    		let photographerAttachmentItems=<React.Fragment></React.Fragment>;
		    		if(item.attachments!=null)
		    		{
			    		photographerAttachmentItems=item.attachments.map((attachItem,j)=>
						{
							if(j==0)
							{
								return(
									<div
									key={j}
									className="attach-img"
									data-value={item.id}
									data-avatars={item.attachments}
									style={{backgroundImage: 'url('+(attachItem.avatar.mini.url)+')', cursor: 'pointer',top:'50px',left:'86px'}}
									onClick={this.handleClickShowAttachmentPhotos}
									>
									</div>
								);

							}
							else if(j==1)
							{
								return(
									<div
									key={j}
									className="attach-img"
									data-value={item.id}
									data-avatars={item.attachments}
									style={{backgroundImage: 'url('+(attachItem.avatar.mini.url)+')', cursor: 'pointer',top:'50px',left:'120px'}}
									onClick={this.handleClickShowAttachmentPhotos}
									>
									</div>
								);
							}
							else{
								return <React.Fragment></React.Fragment>;
							}
						});
			    	}
					let photographerSampleThumbItems=<React.Fragment></React.Fragment>;
					let photographerSampleThumbItemsContainer=<React.Fragment></React.Fragment>;
					
		    		if(item.photos!=null && item.photos.length!=0)
		    		{
						
			    		photographerSampleThumbItems=item.photos.map((photoItem,j) =>
						{
							return(
									<div
									key={j}
									className="sample-img"
									data-value={item.id}
									start-index={j}
									style={{backgroundImage: 'url('+(photoItem.file.thumb.url)+')'}}
									onClick={this.handleClickShowSamplePhotos}
									>
									</div>
								);
						});
						photographerSampleThumbItemsContainer = <React.Fragment>
							<p>{'نمونه کار های '+ (this.props.shootTypeSelectedTitle)+ ' عکاس'}</p>
							<div className="sample-container" >
								{photographerSampleThumbItems}
							</div>
						</React.Fragment>;
					}
					let photographerStudioThumbItems=<React.Fragment></React.Fragment>;
					let photographerStudioThumbItemsContainer=<React.Fragment></React.Fragment>;
		    		if(item.studio_photos!=null && item.studio_photos.length!=0)
		    		{
						
			    		photographerStudioThumbItems=item.studio_photos.map((photoItem,j) =>
						{
							return(
									<div
									key={j}
									className="sample-img"
									data-value={item.id}
									start-index={j}
									style={{backgroundImage: 'url('+(photoItem.photo.thumb.url)+')'}}
									onClick={this.handleClickShowStudioPhotos}
									>
									</div>
								);
						});
						photographerStudioThumbItemsContainer = <React.Fragment>
							<p>فضای داخلی آتلیه</p>
							<div className="sample-container" >
								{photographerStudioThumbItems}
							</div>
						</React.Fragment>;
					}
					

					let priceBoxContainer = <React.Fragment></React.Fragment>;
					
					if(this.props.studiosFilterSelected)
					{
						let studioIsNear =false; 
						let distance = 0;
						if(item.distance_to_you && item.distance_to_you < 7.3)
						{
							studioIsNear =true;
						}
						else
						{
							distance = item.distance_to_you -7.3;
							distance = Math.round(distance);
						}
						if(studioIsNear) {
						priceBoxContainer = <div><p className=" price-box-mobile text-success"><i className="fa fa-check"></i> در محدوده انتخابی </p><p className=" price-box-mobile text-success">{item.stduio_address_detail}</p></div>;
						}
						else{
							priceBoxContainer = <div><p className=" price-box-mobile text-success"><i className="fa fa-check"></i> {'خارج از محدوده انتخابی (فاصله تقریبی از محدوده انتخابی '}{toPersianNumber(distance)}{' کیلومتر می‌باشد.)'} </p><p className=" price-box-mobile text-success">{item.stduio_address_detail}</p></div>;
						}
					}
					else{
						if(item.price=='0')
						{
							priceBoxContainer =<p className=" price-box-mobile text-success"><i className="fa fa-check"></i> در محدوده شما </p>;
						}
						else{
							priceBoxContainer = <p className="price-box-mobile "> <i className="fa fa-taxi text-success"></i>
							{" هزینه رفت و آمد: "+(toPersianNumber(item.price))+ " تومان "}</p>;
						}
					}
					return(
						<React.Fragment>

			                <div className={"item "+(this.state.photographerSelectedId==item.id?'selected light-green' : '')} key={i}>
			                	{/*<div className="special">{specialIcon}</div>*/}
								<header>
									<div className="profile"><h4> {(this.props.studiosFilterSelected)?'آتلیه ':''}{item.first_name.charAt(0)+". "} {item.last_name}</h4></div>
								</header>
								<div className="photographer-avatar-container">
									<div
									className="img"
									data-value={item.id}
									data-avatars={item.attachments}
									onClick={this.handleClickShowAttachmentPhotos}
									style={{backgroundImage: 'url('+(item.avatar.medium.url)+')', cursor: 'pointer'}}
									>
										{item.attachments!=null ? <svg className="svg-book-class" viewBox="0 0 100 100" id={i}>
											<defs>
											    <linearGradient id="gradient" x1="0%" y1="0%" x2="100%" y2="0%">
											      <stop offset="0%" style={{stopColor:'#89216B',stopOpacity:'1'}} />
											      <stop offset="100%" style={{stopColor:'#DA4453',stopOpacity:'1'}} />
											    </linearGradient>
											</defs>
											<circle cx="50" cy="50" r="46"
	    									style={{stroke: 'url(#gradient)'}}/>
								        </svg> : <React.Fragment></React.Fragment>}
									</div>
									{photographerAttachmentItems}
								</div>
								<div className="stars rating">
									{starItems}
								</div>
								{photographerStudioThumbItemsContainer}
								{photographerSampleThumbItemsContainer}
								{/*<button
								className="portfolio-example btn btn-sm btn-default"
	              				style= {{width: "150px"}}
								data-value={item.id}
								onClick={this.handleClickShowSamplePhotos}>
								نمونه کارها
								</button>*/}
								{item.comments_count==0?<div
						              style= {{width: "150px",height: '44px',paddingRight: '30px',paddingLeft: '30px',marginBottom: '15px'}}
						             ></div>
						             :<button
						              className="btn btn-default btn-sm"
						              style= {{width: "100px",background: "#585858",color:"white"}}
						               uid={item.uid}
						               first-name={item.first_name.charAt(0)+". "}
										last-name={item.last_name}
						               onClick={this.showComments}
						               id='comments-button'
						             >
		                        		{"نظرات قبلی"}<i style={{display:(this.state.waitForComments?"":"none")}} className="fa fa-spinner fa-spin"></i>
				           		  	</button>}
					              {priceBoxContainer}

				           		  <div className="row submit-photographer-btn-row">
				           		  		{ item.callable ?<a href={"https://pro.kadro.co/"+(item.uid)+"/call"} target="_blank" className="btn btn-blue more-info-btn call_photographer">تماس با عکاس <span className="fa fa-phone"> </span></a>:<React.Fragment></React.Fragment>}
										{/*<button onClick={this.handleClickOnPhotographerMobileButton} mobile_number={item.mobile_number} className="btn btn-blue more-info-btn call_photographer"> تماس با عکاس <span class="fa fa-phone"> </span> </button>*/}
										<button
										className={"btn "+( this.state.photographerSelectedId==item.id?'btn-selected':'btn-blue') +" choice"}
										complete-first-name={item.first_name}
										first-name={item.first_name.charAt(0)+". "}
										last-name={item.last_name}
										data-selector={item.id}
										item-id={i}
										img-url={item.avatar.medium.url}
										onClick={this.handlePhotographerSelected}
										>
											{this.state.photographerSelectedId==item.id?<i className="fa fa-check green-check"></i> : <React.Fragment></React.Fragment>}
											{this.state.photographerSelectedId==item.id?'انتخاب شد':'انتخاب'}
										</button>

								</div>

							</div>
						</React.Fragment>
		             );
		        });


		if(this.props.availablePhotographers.length>0)
		{
			let title1 = '';
			if(directAndPhotographerSelected)
			{
				title1 = 'عکاس انتخابی شما '+this.props.availablePhotographers[0].first_name.charAt(0)+". "+this.props.availablePhotographers[0].last_name+" می‌باشد.";
			}
			else if(this.props.studiosFilterSelected)
			{
				title1 = (numOfNearPhotographers>0)?((toPersianNumber(numOfNearPhotographers))+' آتلیه در نزدیکی شما '):'هیچ آتلیه ای در نزدیکی شما پیدا نشد';
			}
			else {
				title1 = (numOfNearPhotographers>0)?((toPersianNumber(numOfNearPhotographers))+' عکاس در نزدیکی شما '):'هیچ عکاسی در نزدیکی شما پیدا نشد';
			}
			let title2 = '';
			if(!directAndPhotographerSelected && numOfFarPhotographers>0 && !this.props.studiosFilterSelected)
				title2 = (toPersianNumber(numOfFarPhotographers))+' عکاس از مناطق دیگر با احتساب ';
			else{
				title2 = '';
			}
			let title3 = '';
			if(!directAndPhotographerSelected && numOfFarPhotographers>0 && !this.props.studiosFilterSelected)
			{
				title3 = ' رفت و آمد پیشنهاد شده اند.';
			}
			else if(this.state.photographerSelectedTransportationCost>0  && !this.props.studiosFilterSelected){
				title3 = ' رفت و آمد تا مکان شما '+toPersianNumber(this.state.photographerSelectedTransportationCost)+' تومان می باشد.';
			}
			let title4 ;
			if((directAndPhotographerSelected&&this.state.photographerSelectedTransportationCost==0)||(!directAndPhotographerSelected && numOfFarPhotographers==0))
				title4 =<React.Fragment></React.Fragment>;
			else if(!this.props.studiosFilterSelected)
				title4=<span className="text-danger">حداقل هزینه</span>;

			let title5 ;
			if((directAndPhotographerSelected&&this.state.photographerSelectedTransportationCost==0)||(!directAndPhotographerSelected && numOfFarPhotographers==0))
				title5 =<React.Fragment></React.Fragment>;
			else if(!this.props.studiosFilterSelected)
				title5=<i dataHtml="true" dataToggle="transportation_cost_tooltip" dataPlacement="top" title="حداقل هزینه ایاب ذهاب عکاس از منطقه فعال عکاس تا محل مورد نظر عکاسی شما (معیار محاسبه هزینه اسنپ است.)"><i className="fa fa-info-circle"></i></i>;

		    return (

		    	<React.Fragment>
					<section id="main">
						<div className="container">
							<div className="main">
								<div className="wrapper">
							        <div id="photographer">
							        	<div className="photographer-header">
											<h3 style={{marginTop: '10px',marginBottom: '5px'}}>
	                    						{title1}
	                    					</h3>
											<p  style={{fontSize: '11px'}}>
							                    {title2}
			    								{title4}
			    								{title3}
							                    {title5}

											</p>
										</div>
										<div className="shoot-slider owl-carousel">

	        							{availablePhotographerItems}

										</div>

			        				</div>

			        			</div>
			        			<input type="hidden" name="project_id" id="project_id" value="" />
			        			<input type="hidden" name="photographer" id="shooter" value="" />
								<div className="row full-continue-btn" >
									<div className="col-sm-4 col-sm-offset-4">
										<ContinueButton
										handleSubmitButton={this.handleSubmitButton}
										continueButtonDisabled={!this.state.isPhotographerSelected}
										wait={this.state.waitForContinue}
                                    	payment={false}
										/>
									</div>
	                                <br />
	                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
	                                {(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
									{/*<Tracker
				      					step={this.props.step}
				      				/>*/}
								</div>
								{(mobileDisplay)?<React.Fragment></React.Fragment>:<br />}
			    			</div>
			  			</div>
						<BookFooter
							backButtonDisabled={false}
							previousStep={this.props.previousStep}
							handleSubmitButton={this.handleSubmitButton}
							continueButtonDisabled={!this.state.isPhotographerSelected}
							wait={this.state.waitForContinue}
							payment={false}
						/>
						<WaitingPopup wait={this.state.waitForContinue||this.state.waitForComments||this.state.waitForSamplePhotos}/>
					</section>
					<CommentsPopup
						comments={this.state.comments}
						photographerFirstName={this.state.commentsPhotographerFirstName}
						photographerLastName={this.state.commentsPhotographerLastName}
					/>
					{allPhotographersAttachments}
					<PhotographerSamplePhotos
						photos={this.state.photographerSamplePhotos}
						displayPhotos={this.state.displaySamplePhotos}
						startIndex={this.state.startIndex}
					/>
					<PhotographerStudioPhotos
						photos={this.state.photographerStudioPhotos}
						displayPhotos={this.state.displayStudioPhotos}
						startIndex={this.state.startIndex}
					/>	
		        </React.Fragment>
		    );
		}
		else{
			return(<div></div>);
		}
  }
}
