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

  tryAgain() {
    console.log("try again in result")
    this.props.tryAgain();    
  },

  render() {
    return (
      <div style={styles.root}>
        <h1> Results </h1>
        <a onClick={this.tryAgain}>Try Again </a>
        <div className="grid-list">
          {this.state.result.map(result => (
            <a ref={result.ruby_id} key={result.ruby_id} className="clickable" onClick={this.showResult}> 
              <h3>{ result.score }</h3>
              <div className="grid-item"> 
                {result.name} - {result.location} - {result.location}
              </div>
              <br />
            </a> 
          ))}
        </div>
      </div>
    )  
  }
})