var styles = {
  root: {

  },
  gridList: {

  }
};

const Results = React.createClass({
  getInitialState: function() {
    return {
      result: this.props.result,
      questions: this.props.questions,
    }
  },

  render() {
    return (
      <div style={styles.root}>
        <a onClick={this.increaseQuestionLevelDummy}>Results </a>
        <div className="grid-list">
          {this.state.result.map(result => (
            <a ref={result.ruby_id} key={result.ruby_id} className="clickable" onClick={this.showResult}> 
              <div className="grid-item"> 
                {result.name} - {result.location} - {result.location}
              </div>
            </a> 
          ))}
        </div>
      </div>
    )  
  }
})