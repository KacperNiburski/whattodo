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
      result: undefined
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
    var component = this
    if (newQuestionLevel > 3) {
      console.log("Not setting")
    } else {
      newQuestions = this.props.getQuestions()
      this.setState({questionLevel: newQuestionLevel, questions: newQuestions})      
    }
  },

  tryAgain() {
    console.log("try again in gridlistmodule")
    this.props.tryAgain();
    newQuestionLevel = this.props.getQuestionLevel()
    
    newQuestions = this.props.getQuestions()
    this.setState({questions: newQuestions, questionLevel: newQuestionLevel})
  
  },

  render() {
    let showCurrently;
    if (this.props.result === undefined) {
      showCurrently = <Questions increaseQuestionLevelDummy={this.increaseQuestionLevelDummy} questionLevel={this.state.questionLevel} questions={this.state.questions} switchQuestions={this.switchQuestions}/>
    } else {
      showCurrently = <Results tryAgain={this.tryAgain} questions={this.state.questions} result={this.props.result} />
    }
    return (
      <div style={styles.root}>
        {showCurrently}
      </div>
    )  
  }
})