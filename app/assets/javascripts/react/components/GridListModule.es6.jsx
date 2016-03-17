var styles = {
  root: {

  },
  gridList: {

  }
};

class GridListModule extends React.Component {
  constructor() {
    super()
    this.state = {
      email: ""
    }
  }

  increaseQuestionLevelDummy() {
    debugger   
    this.props.increaseQuestionLevel();
  }

  render() {
    return (
      <div style={styles.root}>
        <h1>{this.props.questionLevel}</h1>
        <a onClick={this.increaseQuestionLevelDummy}>Increase level </a>
        <GridList
          cellHeight={200}
          style={styles.gridList}
        >
          {this.props.questions.map(tile => (
            <GridTile
              key={tile.key}
              title={tile.title}
              subtitle={<span>by <b>{tile.author}</b></span>}
              actionIcon={<IconButton><StarBorder color="white"/></IconButton>}              
            >
              <img src={tile.img} />
            </GridTile>
          ))}
        </GridList>
      </div>
    )  
  }
}