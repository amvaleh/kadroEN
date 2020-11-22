class Popup extends React.Component {
  render () {
    return (
      <React.Fragment>
      <div className="modal fade" id="modalNotes" tabIndex="-1" role="dialog" aria-labelledby="modalNotesTitle" aria-hidden="true">
            <div className="modal-dialog modal-dialog-centered" role="document">
                  <div className="modal-content">
                        <div className="modal-header">
                              <h5 className="modal-title" id="modalNotesLongTitle" style={{color:'red'}}>توجه
                                    <button type="button" className="close" data-dismiss="modal" aria-label="Close">
                                          <span aria-hidden="true">&times;</span>
                                    </button>
                              </h5>

                        </div>
                        <div className="modal-body">
                              <p>
                                    *
                                    مدت عکاسی شامل زمان رسیدن عکاس به محل
                                    <strong style={{color:'#31ce2e'}}>
                                    {' نمی شود؛ '}
                                    </strong>
                                    <br/>
                                    اما زمان مورد نیاز برای راه اندازی و نصب تجهیزات عکاسی
                                    <strong style={{color:'#31ce2e'}}>
                                    {' جزو پکیج شما '}
                                    </strong>
                                    می باشد.
                              </p>
                              <p>
                                    *
                                    هزینه نیم ساعت تمدید
                                    <span style={{color:'#31ce2e'}}>
                                    {' ۷۰.۰۰۰ تومان '}
                                    </span>
                                    و یک ساعت تمدید
                                    <span style={{color:'#31ce2e'}}>
                                    {' ۱۲۰.۰۰۰ تومان '}
                                    </span>
                                    است.
                              </p>
                              <p>
                                    *
                                    ما به شما فایل اصلی عکس را می دهیم.
                              </p>
                              <p>
                                    *
                                    بعد از عکاسی، از گالری خصوصی می توانید سفارش چاپ عکس، شاسی، ماگ و مگنت بدهید.
                                    <br/>
                              </p>

                        </div>
                        <div className="modal-footer">
                              <div className="row">
                                    <div className="col-xs-4">

                                    </div>
                                    <div className="col-xs-4">
                                          <button type="button" className="btn btn-block btn-success" onClick={this.props.saveAndContinue} data-dismiss="modal">باشه</button>
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
