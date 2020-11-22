class CommentsPopup extends React.Component {
	constructor() {
			super();
			this.state = {
				moreClicked:false
			};
			this.handleMoreButton=this.handleMoreButton.bind(this);
	}
	componentDidMount(){
		$("#modalComments").on("hidden.bs.modal", () => {
		    this.setState({moreClicked:false});
		});
	}
	handleMoreButton(){
		this.setState({moreClicked:true});
	}
	render(){
		let mainCommentItems=<div></div>;
		let moreCommentItems=<div></div>;
		if(this.props.comments)
		{
			mainCommentItems=this.props.comments.map((item,i) =>{
				let averageGrade=(item.quality+item.service)/2;
				if(i<4)
				{
					return(
						<CommentItem
			              	text={item.text}
			              	grade={averageGrade}
			              	author={item.user}
							shootType={item.shoot_type}
							count={item.photo_counts}
							duration={item.duration}
							date={item.start_time}
			          	/>
					);
				}
			});
			moreCommentItems=this.props.comments.map((item,i) =>{
				let averageGrade=(item.quality+item.service)/2;
				return(
					<CommentItem
		              	text={item.text}
		              	grade={averageGrade}
		              	author={item.user}
						shootType={item.shoot_type}
						count={item.photo_counts}
						duration={item.duration}
						date={item.start_time}
		          	/>
				);
			});
			if(this.props.comments.length==0){
				mainCommentItems=<p >تاکنون به این عکاس هیچ بازخوردی داده نشده است</p>;
			}
		}
		else{
			mainCommentItems=<p >تاکنون به این عکاس هیچ بازخوردی داده نشده است</p>;
		}

	    return (
				<div className="modal fade" id="modalComments" tabIndex="-1" role="dialog" aria-labelledby="modalCommentsTitle" aria-hidden="true">
	            	<div className="modal-dialog modal-lg modal-dialog-centered" role="document">
	                  	<div className="modal-content modal-commentItem" style={{overflow: 'scroll',maxHeight: '900px'}}>
							<div className="modal-header">
	                              <h5 className="modal-title" id="modalCommentsLongTitle">نظرات مشتریان
	                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close">
	                                          <span aria-hidden="true">&times;</span>
	                                    </button>
	                              </h5>
                                <h3 className="text-center">
                                {this.props.photographerFirstName+" "+this.props.photographerLastName}
                                </h3>
	                        </div>
	                        <div className="modal-body">
	                        	{(this.state.moreClicked)?moreCommentItems:mainCommentItems}
	                        	{(this.props.comments && this.props.comments.length>4)?
								<React.Fragment>
	                        		<div className="row">
										<div className="col-xs-6 col-sm-3 col-sm-offset-3">
											<button className="btn btn-large btn-lg more-comment-button"
											 style={{width: "100%" , display:(this.state.moreClicked)?"none":"block"}}
											 onClick={this.handleMoreButton} >
											 نظرات بیشتر...
						            		</button>
										</div>
										<div className="col-xs-6 col-sm-3">
											<button type="button" className="alert alert-danger btn btn-lg" data-dismiss="modal" aria-label="Close" style={{width:'100%'}}>
	                                          بستن
	                                    	</button>
                                    	</div>
									</div>
									<br />
								</React.Fragment>
								:<React.Fragment></React.Fragment>}

	                    	</div>
						</div>
	            	</div>
	  			</div>
	   );
	}
}
