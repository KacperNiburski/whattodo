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
    if (newQuestionLevel > 3) {
      console.log("Not setting")
      results = this.props.getResults()
      this.setState({result: results})
    } else {
      newQuestions = this.props.getQuestions()
      this.setState({questionLevel: newQuestionLevel, questions: newQuestions})      
    }
  },

  render() {
    let showCurrently;
    if (this.state.result === undefined) {
      showCurrently = <Questions increaseQuestionLevelDummy={this.increaseQuestionLevelDummy} questionLevel={this.state.questionLevel} questions={this.state.questions} switchQuestions={this.switchQuestions}/>
    } else {
      showCurrently = <Results questions={this.state.questions} results={this.state.results} />
    }
    return (
      <div style={styles.root}>
        {showCurrently}
      </div>
    )  
  }
})