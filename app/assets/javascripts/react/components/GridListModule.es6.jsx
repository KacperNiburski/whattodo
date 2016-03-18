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

  switchQuestions() {
    let answer;
    key = 1;

    if (this.state.questions !== undefined ) {      
      this.state.questions.filter(function(_question, _index) {
        if (_question.key == key) {
          answer = _question
        }
      })
    }

    newAttrs = this.props.handeNextLevelClick(key);
    newQuestionLevel = newAttrs[1]
    newQuestions = newAttrs[0]
    this.setState({questionLevel: newQuestionLevel, questions: newQuestions})

  },

  render() {
    return (
      <div style={styles.root}>
        <h1>Increase Level: {this.state.questionLevel}</h1>
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
              actionIcon={<IconButton onClick={this.switchQuestions}><StarBorder color="white"/></IconButton>}              
            >
              <img src={tile.img} />
            </GridTile>
          ))}
        </GridList>
      </div>
    )  
  }
})