let questionsSet = {
  "1": {
    "data": [{
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '0',
    author: 'Q1',
    key: 1
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '10',
    author: 'Q1',
    key: 2
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '20',
    author: 'Q1',
    key: 3
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '50',
    author: 'Q1',
    key: 4
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '100',
    author: 'Q1',
    key: 5
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '1000',
    author: 'Q1',
    key: 6
  }
  ]
  },
  "2": {
    "data": [{
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Run',
    author: 'Q2',
    key: 1
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Walk',
    author: 'Q2',
    key: 2
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Swim',
    author: 'Q2',
    key: 3
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Jump',
    author: 'Q2',
    key: 4
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Skip',
    author: 'Q2',
    key: 5
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Straddle',
    author: 'Q2',
    key: 6
  }
  ]
  },
  "3": {
    "data": [{
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '1',
    author: 'Q3',
    key: 1
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '2',
    author: 'Q3',
    key: 2
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '3',
    author: 'Q3',
    key: 3
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '4',
    author: 'Q3',
    key: 4
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '5',
    author: 'Q3',
    key: 5
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '10',
    author: 'Q3',
    key: 6
  }
  ]
  }
}

const GridListModuleContainer = React.createClass({
  getInitialState: function() {
    return {
      questionLevel: 1,
      questions: questionsSet["1"]["data"],
      answer_1: '',
      answer_2: '',
      answer_3: '',
      result: undefined
    }
  },

  handleNextLevelClick(answer) {
    console.log("changing level")

    this.changeLevel(this.state.questionLevel, answer);
    
    if (this.state.questionLevel <= 3) {      
      this.state.questions = this.getQuestions(this.state.questionLevel)
    }

    return [this.state.questions, this.state.questionLevel]
  },

  getQuestions(questionLevel) {
    this.state.questions = questionsSet[questionLevel]["data"]
  },

  _getQuestionLevel() {
    return this.state.questionLevel
  },

  _getQuestions() {
    return questionsSet[this.state.questionLevel]["data"]
  },

  _getResults() {
    return this.state.result
  },

  increaseQuestionLevel() {
    this.state.questionLevel += 1;
    // setState({questionLevel: this.state.questionLevel + 1})
    console.log(this.state.questionLevel);
    return this.state.questionLevel
  },

  getResult(answer_1, answer_2, answer_3) {    
    let url = `/api/v1/get_rating/${answer_1.title}/${answer_2.title}/${answer_3.title}`;
    var component = this
    $.get(url, function(result, error) {
      // component.state.result = result['events']
      component.setState({result: result['events']})
      debugger
      return result["events"]
    });
  },

  changeLevel(questionLevel, answer) {
    switch (questionLevel) {
      case 1: 
        this.state.answer_1 = answer;
        break;
      case 2:
        this.state.answer_2 = answer;
        break;
      case 3:
        this.state.answer_3 = answer;        
        this.getResult(this.state.answer_1, this.state.answer_2, this.state.answer_3);
        break;

    }

    this.state.questionLevel = this.state.questionLevel + 1;
  },

  render() {
    
    return (
      <div>
        <GridListModule result={this.state.result} getQuestions={this._getQuestions} getQuestionLevel={this._getQuestionLevel} questions={this.state.questions} changeLevel={this.handleNextLevelClick} increaseQuestionLevel={this.increaseQuestionLevel} getResults={this._getResults} questionLevel={this.state.questionLevel} />
      </div>
    )  
  }
})