class ContinueButton extends React.Component  {
    constructor() {
        super();
        this.state = {
            wait:false
        };
    }
    componentWillReceiveProps(nextProps){
        if(nextProps.wait!==this.props.wait)
        {
            this.setState({wait:nextProps.wait});
        }
    }
    render(){
        return (
            <button type="submit" id="submit_page_form" className="btn btn-blue btn-large btn-lg" style={{width: "100%"}} onClick={this.props.handleSubmitButton} disabled={this.props.continueButtonDisabled} >{(!this.props.payment)?'مرحله بعد ':'ثبت و پرداخت سفارش'}
                <i style={{display:(this.state.wait?"":"none")}} className="fa fa-spinner fa-spin"></i>
            </button>
        );
    }
}
