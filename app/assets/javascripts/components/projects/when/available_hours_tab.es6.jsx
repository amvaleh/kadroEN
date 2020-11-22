class AvailableHoursTab extends React.Component {
	componentDidMount(){
		let figure=$('#time-picker').find('figure');
		let header=$('#time-picker').find('header');


		figure.on('click', '.times ul li',  (clickEvt)=> {

		    figure.find('.times ul li').removeClass('selected');
		    $('#time').val($(this).html());

		    $(clickEvt.target).addClass('selected');


//////////////preparing for receipt page show date time
		    let persianDate= header.text().split(' - ').join(' ');
			var data={
				dateSelected:persianDate,
				timeSelected:$(clickEvt.target).text(),
			}
			this.props.persianDateTimeData_callBack(data);

/////////////////////////////////////////////////////////////////////////////////////


		    let dateTime=this.props.dateSelected+' '+convertPersianDigitsToLatin($(clickEvt.target).text());

		    this.props.dateTimeSelected(dateTime);

		    this.props.isTimeSelected(true);
	  	});
	}

	componentWillReceiveProps(nextProps){
		let figure=$('#time-picker').find('figure');

		if(nextProps.dateSelected!==this.props.dateSelected)
		{
			//if date changed remove time selected
			figure.find('.times ul li').removeClass('selected');
            
		}
	}

	render () {
		let availableHourItems= this.props.availableHours
	    	.map((object,i) =>
	    	{

	    		let sectionAvailableHours=object.times.map((item,j) =>
             	{
             		return(
             			<li key={j}>{item}</li>
             			);
                });
				return(
	                <div className="col-xs-4 times" key={i}>
						<h4>{object.time_name}</h4>
						<ul>
	                    	{sectionAvailableHours}
	                    </ul>
	                </div>
	             );
	        });
		return (
		      <React.Fragment>
		      	{availableHourItems}
		      </React.Fragment>
		);
	}
}
