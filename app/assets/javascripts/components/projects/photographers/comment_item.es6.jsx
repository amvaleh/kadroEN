function CommentItem(props) {
	/*let gradeIcon = <div></div>;
	if(props.grade>6.6){
		gradeIcon=<i className='fa fa-smile'>{props.grade}</i>;
	}
	else if(props.grade<=3.3){
		gradeIcon=<i className='fa fa-frown'>{props.grade}</i>;
	}
	else{
		gradeIcon=<i className='fa fa-meh'>{props.grade}</i>;
	}*/
	return (
		<div className='well'>
	      	<div className=" commentItem-box-mobile">
           		<div className='row'>
	           		<div className='col-sm-9 col-md-6 commentItem-title' style={{color: "black"}} >
						{" - "+props.author} ({"عکاسی "+props.shootType}):
					</div>
	           		<div className='pull-left col-sm-3 commentItem-grade text-right'>
						{"نمره: "+toPersianNumber(props.grade)+" از ۱۰"}
					</div>
				</div>
				<div className='row commentItem-text' style={{margin: "1% 0%"}} >
	       		  	<div style={{color: '#255bdc'}}>
	       		  		{""+props.text}
					</div>
				</div>
				<div className='row commentItem-footer'>
					<div className='col-xs-4 col-sm-4'>
						<i className='fa fa-clock-o'></i>{" "+toPersianNumber(props.duration)+" ساعت"}
					</div>
					<div className='col-xs-4 col-sm-4'>
						<i className='fa fa-image'></i>{" "+toPersianNumber(props.count)+" عکس"}
					</div>
					<div className='col-xs-4 col-sm-4'>
						<i className='fa fa-calendar'>{" "+props.date}</i>
					</div>
				</div>
   		   	</div>
      </div>
	);
}
