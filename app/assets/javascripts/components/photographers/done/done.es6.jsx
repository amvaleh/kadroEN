class Done extends React.Component {
	constructor(props) {
		super(props);
		this.state = {


		};
		this.handlePortfolioButtonClick=this.handlePortfolioButtonClick.bind(this);
		this.handleExperienceButtonClick=this.handleExperienceButtonClick.bind(this);
		this.handleEquipmentButtonClick=this.handleEquipmentButtonClick.bind(this);
		this.handleInfoButtonClick=this.handleInfoButtonClick.bind(this);
	}
	handlePortfolioButtonClick(){
		this.props.portfolioStep();
	}
	handleExperienceButtonClick(){
		this.props.experienceStep();
	}
	handleEquipmentButtonClick(){
		this.props.equipmentStep();
	}
	handleInfoButtonClick(){
		this.props.infoStep();
	}
	render () {
		return (
			<React.Fragment>
				<section id="main">
					<div className="container">
						<div className="main">
							<div className="wrapper">
								<div className="row">
									<div className="col-md-12">
				          				<p className="text-center">
		              						{(this.props.firstName)+' '+(this.props.lastName)+' عزیز ممنون از وقتی که گذاشتید، تیم کارشناسی کادرو فرم شما را بررسی می کند و در اسرع وقت با شما تماس می گیرد.'}
				              				<br />
				              				به دلیل تعداد بالای متقاضیان، ممکن است کمی طول بکشد تا با شما تماس بگیریم،
				              				<br />
	              			  				از اینکه در این خصوص با ما همکاری میکنید سپاس گزاریم.
	            						</p>
							            <h3 className="text-center">
							              {'صفحه شما: '}
							              <a href={'http://'+(this.props.uid)+'.kadro.co'}>{(this.props.uid)+'.kadro.co'}</a>
							              
							            </h3>
							            <div className="text-center">
											<br /> 
											<a className="btn btn-default" style={{marginLeft:'2%'}} onClick={this.handleInfoButtonClick}>ویرایش اطلاعات اولیه و مکانی</a> {/*infos*/}
											<a className="btn btn-default" style={{marginLeft:'2%'}} onClick={this.handleEquipmentButtonClick}>ویرایش تجهیزات عکاسی</a>	{/*equipments*/}											
											<a className="btn btn-default" style={{marginLeft:'2%'}} onClick={this.handlePortfolioButtonClick}>ویرایش نمونه کارها</a> {/*portfolio*/}
											<a className="btn btn-default" onClick={this.handleExperienceButtonClick}>ویرایش تجربه کاری</a>	{/*experience*/}
											
											<br />
											<br />
											<a className="btn btn-default" href="https://www.instagram.com/kadro.college/">
												<img title="kadro college" src="/logo_college.png" style={{width:'60px'}} />
                                                پیج اینستاگرام کادرو کالج
											</a>
							             
							            </div>
	           
									</div>
								</div>
							</div>
	    				</div>
 					</div>
				</section>
				<footer id="footer">
					<div className="container">
						<div className="wrap">
						</div>
					</div>
				</footer>
			</React.Fragment>
		);
	}
}