var styles = {
  root: {
    // display: 'flex',
    // flexWrap: 'wrap',
    // justifyContent: 'space-around',
  },
  gridList: {
    // width: 500,
    // height: 400,
    // overflowY: 'auto',
    // marginBottom: 24,
  }
};

const GridListModule = React.createClass({
  getInitialState: function() {
    return {
      questions: this.props.data || questionsSet,
      questionLevel: this.props.questionLevel || 1
    }
  },

  handleNextLevelClick: function(key) {
    let answer = this.state.questions.filter({
      return key === item.key
    })

    this.props.changeLevel(this.props.questionLevel, answer);
    this.state.questionLevel = this.state.questionLevel + 1;
    this.state.questions = this.props.getQuestions(questionLevel)
  },

  render() {
    return (
      <div style={styles.root}>
        <h1>{this.state.questionLevel}</h1>
        <GridList
          cellHeight={200}
          style={styles.gridList}
        >
          {this.state.questions.map(tile => (
            <GridTile
              key={tile.key}
              title={tile.title}
              subtitle={<span>by <b>{tile.author}</b></span>}
              actionIcon={<IconButton><StarBorder color="white"/></IconButton>}
              onClick={this.handleNextLevelClick(tile.key)}
            >
              <img src={tile.img} />
            </GridTile>
          ))}
        </GridList>
      </div>
    )  
  }
})