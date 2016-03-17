class Button extends React.Component {
  constructor() {
    super()
    this.state = {
      text: this.props.text
    }
  }

  questionLevelDummy() {
    this.props.increaseQuestionLevel()
  }

  render () {
    return (
      <div>
        <div onClick={this.questionLevelDummy.bind(this)}>Text: {this.state.text}</div>
      </div>
    );
  }
}

Button.propTypes = {
  text: React.PropTypes.string
};
