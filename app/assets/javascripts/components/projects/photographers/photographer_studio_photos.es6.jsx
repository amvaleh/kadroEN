class PhotographerStudioPhotos extends React.Component {
	constructor() {
		super();
		this.state = {
			displayPhotos:false,
			
		};
}
componentDidUpdate(){

	
	if(this.state.displayPhotos)
	{
		$('#studio_fotorama') .on('fotorama:fullscreenexit ', function (e, fotorama) {
			if(mobileDisplay)
				$('.fotorama__fullscreen-icon').addClass('mobile-exited');
		}).fotorama({
			  width: '100%',
			  ratio:(!mobileDisplay)?'15/6':'1',
			  allowfullscreen: true,
			  nav: 'thumbs',
			  swipe: true,
		});
	
	}
		
			

}
componentWillReceiveProps(nextProps){

	if(nextProps.displayPhotos !== this.props.displayPhotos)
	{
		this.setState({displayPhotos: nextProps.displayPhotos});
		this.setState({startIndex:nextProps.startIndex});

	}
}
render(){
	let size=0;
	if(mobileDisplay)
		size=64;
	else
		size=80
	if(this.state.displayPhotos)
	{
		let photos = this.props.photos.map((item,i) =>
			{

				return(
					<img 
					key={i}
					src={item.photo.medium.url} 
					data-thumb={item.photo.thumb.url} 
					data-full={item.photo.large.url} 
					>
					</img>
					

				);
			});
		return(
			<section id="portfolios" className="open studio_photos">
				
					<span className="btn close">بستن</span>
					<div className="inner " id="studio_fotorama" data-startindex={this.props.startIndex} data-thumbwidth={size} data-thumbheight={size}>
						{photos}
					</div>
			</section>
		);
		
	}
	else{

		return(<section id="portfolios" className="studio_photos">

					<div className="inner " id="studio_fotorama">
						
					</div>
			</section>);

	}


}
}
