const Button = React.createClass({
  getInitialState: function() {
    return {
      text: this.props.text,
    }
  },

  questionLevelDummy() {
    this.props.increaseQuestionLevel()
    console.log("Inside component")
    console.log(this.props.text);
    this.setState({text: parseInt(this.state.text) + 1})
  },

  render () {
    console.log(this.props.text);
    console.log(this.state.text);
    return (
      <div>
        <div onClick={this.questionLevelDummy}>Text: {this.state.text}</div>
      </div>
    );
  }
})
