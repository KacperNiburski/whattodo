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
  "3": {
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
  }
}

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
      answer_1: '',
      answer_2: '',
      answer_3: '',
      result: []
    }
  },

  handleNextLevelClick: function(key) {
    
  },

  getQuestions(questionLevel) {
    let questionString = questionLevel.toString();
  },

  increaseQuestionLevelDummy() {    
    this.props.increaseQuestionLevel();
  },

  getResult(answer_1, answer_2, answer_3) {
    
  },

  changeLevel(questionLevel, answer) {
  },

  render() {
    return (
      <div style={styles.root}>
        <h1>{this.props.questionLevel}</h1>
        <a onClick={this.increaseQuestionLevelDummy}>Increase level </a>
        <GridList
          cellHeight={200}
          style={styles.gridList}
        >
          {this.state.questions.map(tile => (
            <GridTile
              key={tile.key}
              title={tile.title}
              subtitle={<span>by <b>{tile.author}</b></span>}
              actionIcon={<IconButton onClick={this.handleNextLevelClick(tile.key)}><StarBorder color="white"/></IconButton>}              
            >
              <img src={tile.img} />
            </GridTile>
          ))}
        </GridList>
      </div>
    )  
  }
})