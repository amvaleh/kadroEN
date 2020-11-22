


class RulesPopUp extends React.Component{
      constructor(props) {
            super();
            this.state = {
			checked:false,
            };
            this.handleChangeCheckBox=this.handleChangeCheckBox.bind(this);
            this.handleSubmitButton=this.handleSubmitButton.bind(this);
            this.handleCheckBoxControlClick=this.handleCheckBoxControlClick.bind(this);
            
      }
      handleChangeCheckBox(event){
            this.setState({checked:event.target.checked})
      }
      handleSubmitButton(){
            this.props.submitCallBack();
            this.setState({checked:false});
      }
      handleCheckBoxControlClick(){
            this.setState({checked:!this.state.checked});
      }
      render(){
            return (
                  <React.Fragment>
                        <div className="ui modal container" id="modalPhotoNotes" style={{marginBottom: "3.5rem"}}>
                        
                              <div className="header" style={{textAlign:'center',color:'red'}}>
                              توجه
                              </div>
                              <button type="button" className="close icon" aria-label="Close">
                                    <span aria-hidden="true">&times;</span>
                              </button>
                              <div className="content">
                                    <div className="ui header" style={{textAlign:'right',color:'red'}}>
                                          <p style={{textAlign:'right',color:'red'}}>عکاس محترم</p>
                                          <p style={{textAlign:'right',color:'red'}}>پیش از آپلود نمونه کار، به موارد زیر توجه ویژه کنید. بدیهی است عدم رعایت موارد اعلام شده باعث تأخیر در بررسی و حتی لغو عضویت شما خواهد شد.</p>
                                    </div>
                                    <p style={{textAlign:'right'}}>💡   حداقل 6 نمونه کار حرفه ای و جذاب برای رشته های عکاسی انتخاب شده آپلود کنید. پروفایل هایی که نمونه کار بیشتری آپلود کنند در اولویت بررسی قرار خواهند گرفت.</p>
                                    <p style={{textAlign:'right'}}>💡   شایان توجه است بررسی پروفایل شما و همچنین انتخاب شما تحت عنوان عکاس برای یک پروژه به نمونه کارهای آپلودی شما وابسته است، لذا در انتخاب عکس ها وسواس حداکثری داشته باشید.</p>
                                    <p style={{textAlign:'right'}}>💡  از آپلود عکس هایی که اجازه انتشار آنها را ندارید به شدت خودداری کنید.  ( حتی با مخدوش کردن چهره افراد )</p>
                                    <p style={{textAlign:'right'}}>💡  تمامی نمونه کارهای آپلودی می بایست بدون واترمارک بوده و از آپلود عکس های دارای افکت های گرافیکی، تایپوگرافی و شیت بندی شده خودداری کنید.</p>
                                    <p style={{textAlign:'right'}}>💡  از آپلود عکس های دارای قاب سفید یا مشکی خودداری کنید.</p>
                                    <p style={{textAlign:'right'}}>💡  نمونه کارهای آپلود شده در رشته تبلیغاتی و صنعتی ( زمینه سفید ) می بایست از محصولات متنوع باشند. ( متریال، ابعاد و اندازه و کاربری )</p>
                                    <p style={{textAlign:'right'}}>💡  نمونه کارهای آپلود شده در رشته پوشاک و لباس، چهره و پروفایل و سایر رشته های سوژه محور می بایست متنوع باشند. ( عکس های فضای باز محبوبیت بیشتری دارند )</p>
                                    <br />
                                    <p style={{textAlign:'right'}}>📢 نمونه عکس های زیر که با توجه به موارد اعلام شده، تایید نخواهند شد !   </p>
                                    <div className="row modal-row">
                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample3.jpg" className="img-responsive" />
                                          </div>

                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample4.jpg" className="img-responsive" />
                                          </div>
                                    </div>
                                    <div className="row modal-row">
                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample5.jpg" className="img-responsive"  />
                                          </div>

                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample7.jpg" className="img-responsive" />
                                          </div>
                                    </div>
                                    <div className="row modal-row">
                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample1.jpg" className="img-responsive" />
                                          </div>

                                          <div className="col-lg-6 col-md-6 col-sm-6 col-xs-12">
                                                <img src="/img/wrong_sample2.jpg" className="img-responsive" />
                                          </div>
                                    </div>
                                    <div className="row modal-row form-group">
                                          <div className="checkbox-control" onClick={this.handleCheckBoxControlClick}>
                                                <input 
                                                type="checkbox" 
                                                id="rule-checkbox" 
                                                required
                                                data-parsley-pattern-message="این مقدار باید حروف فارسی باشد"
                                                onChange = {this.handleChangeCheckBox}
                                                checked={this.state.checked}
                                                />
                                                <label style={{width: "inherit"}}>
                                                من مطالب فوق را مطالعه کرده ام
                                                </label>
                                          </div>
                                    </div>
                              </div>
                              <div className="actions" >
                                    <div className="col-md-4 col-md-offset-4">
                                          <button className="btn btn-blue btn-large btn-lg" style={{width: "100%" , marginBottom: '2rem'}} disabled={!this.state.checked} onClick={this.handleSubmitButton}>ادامه</button>
                                    </div>
                              </div>
                        </div>
                  </React.Fragment>
            );
      }
};
