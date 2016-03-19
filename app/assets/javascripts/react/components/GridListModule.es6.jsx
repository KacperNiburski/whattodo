var styles = {
  root: {

  },
  gridList: {

  }
};

const GridListModule = React.createClass({
  getInitialState: function() {
    return {
      questionLevel: this.props.questionLevel,
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
    console.log(newQuestionLevel)
    if (newQuestionLevel > 3) {
      console.log("Not setting")
    } else {
      newQuestions = this.props.getQuestions()
      this.setState({questionLevel: newQuestionLevel, questions: newQuestions})      
    }
  },

  render() {
    return (
      <div style={styles.root}>
        <h1>Increase Level: {this.state.questionLevel}</h1>
        <a onClick={this.increaseQuestionLevelDummy}>Increase level </a>
        <div className="grid-list">
          {this.state.questions.map(question => (
            <a ref={question.key} key={question.key} className="clickable" onClick={this.switchQuestions}> 
              <div className="grid-item"> 
                {question.title} - {question.author} 
              </div>
            </a> 
          ))}
        </div>
      </div>
    )  
  }
})