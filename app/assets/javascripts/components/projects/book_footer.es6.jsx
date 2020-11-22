function BookFooter(props) {

  return (
  	<footer id="footer">
        <div className="container">
            <div className="wrap">
                <a className="back-btn btn btn-default btn-lg" onClick={props.previousStep} disabled={props.backButtonDisabled}> <i className="fa fa-arrow-right" ></i>  بازگشت </a>
                <button type="submit" id="submit_page_form" className="next-btn btn btn-blue btn-large btn-lg" onClick={props.handleSubmitButton} disabled={props.continueButtonDisabled} >{(props.payment)?'ثبت و پرداخت ':'مرحله بعد '}
                <i style={{display:(props.wait?"":"none")}} className="fa fa-spinner fa-spin"></i>
                </button>
            </div>
        </div>
	</footer>
	);
}
