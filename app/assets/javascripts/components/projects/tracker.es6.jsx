function Tracker(props) {

  return (
  	<div className="tracker">
          <div className="process-tabs-line w-hidden-tiny">
              <span className={"step-line "+((props.step>1)?'active':'')} style={{width: '25%', right: '0%'}}></span>
              <span className={"step-line "+((props.step>2)?'active':'')} style={{width: '25%', right: '25%'}}></span>
              <span className={"step-line "+((props.step>3)?'active':'')} style={{width: '25%', right: '50%'}}></span>
              <span className={"step-line "+((props.step>4)?'active':'')} style={{width: '25%', right: '75%'}}></span>
          </div>

          <div className={"process-tab-button tracker-circle "+((props.step>=1)?'selected':'')} style={{right: '0%'}}>
              <div className="tracker-text">
              انتخاب تعرفه
              </div>
          </div>
          <div className={"process-tab-button tracker-circle "+((props.step>=2)?'selected':'')} style={{right: '25%'}}>
              <div className="tracker-text">
                  مکان
              </div>
          </div>
          <div className={"process-tab-button tracker-circle "+((props.step>=3)?'selected':'')} style={{right: '50%'}}>
              <div className="tracker-text">
                  زمان
              </div>
          </div>
          <div className={"process-tab-button tracker-circle "+((props.step>=4)?'selected':'')} style={{right: '75%'}}>
              <div className="tracker-text">
              عکاس
              </div>
          </div>
          <div className={"process-tab-button tracker-circle "+((props.step>=5)?'selected':'')} style={{right: '100%'}}>
              <div className="tracker-text">
              استایل
              </div>
          </div>
      </div>
	);
}
