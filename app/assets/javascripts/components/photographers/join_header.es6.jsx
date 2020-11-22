class JoinHeader extends React.Component {
	constructor() {
		super();
		this.state = {


		};

	}
	render () {
		if(this.props.signedIn){
			return (
		
				<header id="header">
					<nav className="nav">
						<div className="container">
							<div className="wrap">
								<a href="https://kadro.co" title="" className="logo" target="_blank">
									<img src="/img/logo.png" alt="title" />
								</a>
								<div className="btn-group">
            						<a className=" btn btn-warning" href="/photographers/sign_out">خروج</a>
          						</div>
							</div>
						</div>
					</nav>
					<div className="header">
						<div className="container">
							<h2 className="">
							{this.props.title}
							</h2>
						</div>
					</div>
				</header>
			);
		}
		else{
			return (
		
				<header id="header">
					<nav className="nav">
						<div className="container">
							<div className="wrap">
								<a href="https://kadro.co" title="" className="logo" target="_blank">
									<img src="/img/logo.png" alt="title" />
								</a>
								<div className="btn-group">
						            <a className=" btn btn-default " href="/photographers/sign_in">ورود</a>
						            <a className="btn btn-blue" href="/">رزرو عکاس</a>
					          </div>
							</div>
						</div>
					</nav>
					<div className="header">
						<div className="container">
							<h2 className="">
							{this.props.title}
							</h2>
						</div>
					</div>
				</header>
			);
		}
	}	
		
}
