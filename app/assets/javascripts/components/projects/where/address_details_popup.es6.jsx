class AddressDetailsPopup extends React.Component {
	constructor(props) {
		super(props);
		this.handleAddressDetailChange=this.handleAddressDetailChange.bind(this);
            this.handleSubmitButton=this.handleSubmitButton.bind(this);
      }
	handleAddressDetailChange(event){
            this.props.addressDetailInitCallBack(event.target.value);
	}
	handleSubmitButton(){
		$('#address-details').parsley().validate();
		if(!$('#address-details').parsley().isValid())
		{
			let target = $('#address-details');
            if( target.length ) {
	          	$('html, body').stop().animate({
	              scrollTop: target.offset().top
	          	}, 1000);
	        }
			return;
		}
		else
			this.props.submitButtonCallBack();
	}
  render () {
    return (
      <React.Fragment>
      <div className="modal" id="modalNotes" tabIndex="-1" role="dialog" aria-labelledby="modalNotesTitle" aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered" role="document">
                  <div className="modal-content">
                        <div className="modal-header">
                              <h5 className="modal-title text-center" id="modalNotesLongTitle" style={{color:'black'}}>
                              آدرس متنی شما
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                          <span aria-hidden="true">&times;</span>
                                    </button>
                              </h5>

                        </div>
                        <div className="modal-body">

                              <div className="form-group">
								<label htmlFor="address-details"> آدرس دقیق محل: </label>
								<textarea
								className="form-control"
                                                name="address-details"
                                                id="address-details"
								rows="7"
								required
								placeholder="جزئیات آدرس، برای مثال کوچه، پلاک، طبقه یا محل ملاقات با عکاس"
                                                onChange={this.handleAddressDetailChange}
                                                value={this.props.value}
								data-parsley-trigger="keyup"
								></textarea>

							</div>
                        </div>
                        <div className="modal-footer">
                              <div className="row">
                                    <div className="col-xs-4">

                                    </div>
                                    <div className="col-xs-4">
                                          <button type="button" className="btn btn-block btn-blue" onClick={this.handleSubmitButton} > مرحله بعد </button>
                                    </div>
                                    <div className="col-xs-4">

                                    </div>
                              </div>

                        </div>
                  </div>
            </div>
      </div>
      </React.Fragment>
    );
  }
}
