var styles = {
  root: {

  },
  gridList: {

  }
};

const Results = React.createClass({
  getInitialState: function() {
    return {
      result: this.props.result['events'],
      questions: this.props.questions,
    }
  },

  increaseQuestionLevelDummy() { 
    newQuestionLevel = this.props.increaseQuestionLevel();
    this.setState({questionLevel: newQuestionLevel})
  },

  switchQuestions(event) {
    let answer;
    let text = event.currentTarget.text.split('-')[0].replace(/\s/, '')
    if (this.state.questions !== undefined ) {      
      this.state.questions.filter(function(_question, _index) {
        if (_question.title === text) {
          answer = _question
        }
      })
    }

    this.props.changeLevel(answer);

    newQuestionLevel = this.props.getQuestionLevel()
    newQuestions = this.props.getQuestions()

    this.setState({questionLevel: newQuestionLevel, questions: newQuestions})
  },

  render() {
    return (
      <div style={styles.root}>
        <a onClick={this.increaseQuestionLevelDummy}>Increase level </a>
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