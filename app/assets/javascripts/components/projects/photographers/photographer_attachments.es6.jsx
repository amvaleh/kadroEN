class PhotographerAttachments extends React.Component {

	componentDidMount(){
		$('#close'+(this.props.photographerId)).on('click', ()=> {
	      $('#main').removeClass('blur');
	      this.props.closeCallBack();
	    });
	    $('#attachments'+(this.props.photographerId)).on('click', (e)=> {
	    	if (!document.getElementById('outer'+(this.props.photographerId)).contains(e.target)){
			    // Clicked out of image and thumbnail
			    $('#main').removeClass('blur');
	      		this.props.closeCallBack();
		  	}

	    });
	}
	render () {
		let largePhotos=<div></div>;
		let photoThumbnails=<div></div>;
		if(this.props.photos!=null)
		{
			largePhotos=this.props.photos.map((item,i)=>
				{
					if(i==0)
					{
						return(
							<div className="item active" key={i}>

								<img src={item.avatar.large.url} alt=""/>

							</div>
						);

					}
					else{
						return(
							<div className="item" key={i}>

								<img src={item.avatar.large.url} alt=""/>

							</div>
						);
					}

				});
			photoThumbnails=this.props.photos.map((item,i) =>
				{
					if(i==0)
					{
						return(
							<li data-target={"#attachments"+(this.props.photographerId)} data-slide-to={i} key={i}  className="active">
								<img src={item.avatar.mini.url} alt='' />
							</li>

						);
					}
					else{
						return(
							<li data-target={"#attachments"+(this.props.photographerId)} data-slide-to={i} key={i} >
								<img src={item.avatar.mini.url} alt='' />
							</li>

						);
					}
				});
		}
		return (

			    <div id={"attachments"+(this.props.photographerId)} className="carousel slide open" data-ride="carousel" >
			    	<div className="inner">
						<i data-dismiss="modal" className="fa fa-times fa-4x close" style={{color: '#ffffff',
					    position: 'absolute',
					    zIndex: '2',
					    background: '#ffffff42',
					    borderRadius: '18px',
					    fontSize: '25px',
					    padding: '7px'}} id={'close'+(this.props.photographerId)} aria-hidden="true"></i>
						<div className='carousel-outer' id={"outer"+(this.props.photographerId)}>
							{/* <!-- The slideshow -->*/}
							<div className="carousel-inner" id={"inner"+(this.props.photographerId)}>
								{largePhotos}
							</div>
							{/*<!-- Left and right controls -->*/}
							<a className="left carousel-control" href={"#attachments"+(this.props.photographerId)} data-slide="next">
                            	<i className="fa fa-chevron-left"></i>
                            </a>
                            <a className="right carousel-control" href={"#attachments"+(this.props.photographerId)} data-slide="prev">
                              <i className="fa fa-chevron-right"></i>
                            </a>
							 {/*}-- Indicators -->*/}
							<ul className="carousel-indicators" id={"indicator"+(this.props.photographerId)}>
								{photoThumbnails}
							</ul>
						</div>


					</div>

				</div>

		);



	}
}
{/*<div id="attachments" className="carousel slide open" data-ride="carousel">
				    	<div className="inner">
							<i data-dismiss="modal" className="fa fa-times fa-4x close" style={{color: '#ffffff',
						    position: 'absolute',
						    zIndex: '2',
						    background: '#ffffff42',
						    borderRadius: '18px',
						    fontSize: '25px',
						    padding: '7px'}} aria-hidden="true"></i>
							<div className='carousel-outer'>
								<div className="carousel-inner" id="inner2">
								    <div className="item active">
								       <img src="http://placekitten.com/960/600" />
								     </div>
								     <div className="item">
								       <img src="http://placebear.com/960/600" />
								   </div>
								   <div className="item">
								       <img src="http://lorempixel.com/960/600" />
								   </div>



								    </div>
								<a className="left carousel-control" href="#attachments" data-slide="next">
                                	<i className="fa fa-chevron-left"></i>
                                </a>
                                <a className="right carousel-control" href="#attachments" data-slide="prev">
                                  <i className="fa fa-chevron-right"></i>
                                </a>
								<ul className="carousel-indicators">
									<li data-target="#attachments" data-slide-to="0" className="active"><img src='http://placehold.it/100x50&text=slide1' alt='' /></li>
									<li data-target="#attachments" data-slide-to="1"><img src='http://placehold.it/100x50&text=slide2' alt='' /></li>
									<li data-target="#attachments" data-slide-to="2"><img src='http://placehold.it/100x50&text=slide3' alt='' /></li>

								</ul>
							</div>


						</div>

					</div>*/}
