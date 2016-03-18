let questionsSet = {
  "1": {
    "data": [{
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Happy',
    author: 'Q1',
    key: 1
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Sad',
    author: 'Q1',
    key: 2
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Mad',
    author: 'Q1',
    key: 3
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Glad',
    author: 'Q1',
    key: 4
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Run',
    author: 'Q1',
    key: 5
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: 'Jump',
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
    title: '0',
    author: 'Q3',
    key: 1
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '10',
    author: 'Q3',
    key: 2
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '20',
    author: 'Q3',
    key: 3
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '30',
    author: 'Q3',
    key: 4
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '80',
    author: 'Q3',
    key: 5
  },
  {
    img: 'https://pbs.twimg.com/profile_images/638751551457103872/KN-NzuRl.png',
    title: '200',
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
      result: []
    }
  },

  handleNextLevelClick: function(key) {
    let answer;

    this.changeLevel(this.state.questionLevel, answer);
    this.state.questionLevel += 1;
    this.state.questions = this.getQuestions(this.state.questionLevel)

    return [this.state.questions, this.state.questionLevel]
  },

  getQuestions(questionLevel) {
    let questionString = questionLevel.toString();
    this.state.questions = questionsSet[questionString]["data"]
  },

  increaseQuestionLevel() {
    this.state.questionLevel += 1;
    // setState({questionLevel: this.state.questionLevel + 1})
    console.log(this.state.questionLevel);
    return this.state.questionLevel
  },

  getResult(answer_1, answer_2, answer_3) {
    let url = `/get_rating/${answer_1}/${answer_2}/${answer_3}`;
    $.get(url, function(result, error) {
      if (error) return;
      this.state.result = result
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
        this.getResult(answer_1, answer_2, answer_3);
        break;

    }

    this.state.questionLevel = this.state.questionLevel + 1;
  },

  render() {
    return (
      <GridListModule changeLevel={this.handleNextLevelClick()} increaseQuestionLevel={this.increaseQuestionLevel} questionLevel={this.state.questionLevel} questions={this.state.questions} />
    )  
  }
})