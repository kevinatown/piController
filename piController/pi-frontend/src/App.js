import React, { Component } from 'react';
import $ from 'jquery';
import {
  Button,
  Label,
  Input,
  Form,
  FormGroup,
} from 'reactstrap';
import Icon from 'react-icons-kit';
import { arrowUp } from 'react-icons-kit/fa/arrowUp';
import { arrowDown } from 'react-icons-kit/fa/arrowDown';
import { arrowLeft } from 'react-icons-kit/fa/arrowLeft';
import { arrowRight } from 'react-icons-kit/fa/arrowRight';
import { handStopO } from 'react-icons-kit/fa/handStopO'; 
import 'bootstrap/dist/css/bootstrap.css';
import './App.css';

class App extends Component {

  constructor(props){
    super(props);
    this.state = {
      message: 'is stopped',
      status: true,
      name: 'RoboPi',
    };
    this.movePi = this.movePi.bind(this);
    this.getDir = this.getDir.bind(this);
    this.changeRoboName = this.changeRoboName.bind(this);
  }

  changeRoboName(e) {
    this.setState({ name: e.target.value });
  }

  getDir(num) {
    switch(num){
      case 1: return 'is moving forward';
      case 2: return 'is moving backwards';
      case 3: return 'is moving right';
      case 4: return 'is moving left';
      default: return 'is stopped';
    }
  }

  movePi(num) {
    $.get(`/move/${num}`).then((response) => {
      if (num <= 5) {
        this.setState({ message: this.getDir(num), status: response.success });
      } else {
        this.setState({ status: response.success });
      }
    });
  }

  render() {
    return (
      <div className="App">
        <header className="App-header">
          <h1 className="App-title">Control your GoPiGo!</h1>
        </header>
        <div className="content container">
          <div className="row header">
            <div className="col-12">
              <div className="d-flex justify-content-center">
                <h3>{`${this.state.name} ${this.state.message}`}</h3>
              </div>
              <div className="d-flex justify-content-center">
                <Form inline>
                  <FormGroup>
                    <Label for="robotName">Robot's name: </Label>
                    {' '}
                    <Input onChange={this.changeRoboName} value={this.state.name} type="robotName" name="robotName" id="robotName" placeholder="Robot's Name" />
                  </FormGroup>
                </Form>
              </div>
            </div>
          </div>
          <div className="row">
            <div className="col-6">
              <h5>Speed Control</h5>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(6)} color="info"><Icon icon={arrowUp}/></Button>
              </div>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(7)} color="info"><Icon icon={arrowDown}/></Button>
              </div>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(5)} size="lg" block color="danger"><Icon icon={handStopO}/></Button>
              </div>
            </div>
            <div className="col-6">
              <h5>Movement Control</h5>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(1)} color="info"><Icon icon={arrowUp}/></Button>
              </div>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(2)} color="info"><Icon icon={arrowLeft}/></Button>
                <Button onClick={() => this.movePi(3)} color="info"><Icon icon={arrowRight}/></Button>
              </div>
              <div className="d-flex justify-content-center">
                <Button onClick={() => this.movePi(4)} color="info"><Icon icon={arrowDown}/></Button>
              </div>
            </div>
          </div>
        </div>
      </div>
    );
  }
}

export default App;
