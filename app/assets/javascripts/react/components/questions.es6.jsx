const Questions = React.createClass({
  
  render () {
    return (
      <div>
        <h1>Increase Level: {this.props.questionLevel}</h1>
        <a onClick={this.props.increaseQuestionLevelDummy}>Increase level </a>
        <div className="grid-list">
          {this.props.questions.map(question => (
            <a ref={question.key} key={question.key} className="clickable" onClick={this.props.switchQuestions}> 
              <div className="grid-item"> 
                {question.title} - {question.author} 
              </div>
            </a> 
          ))}
        </div>

      </div>
    );
  }
})