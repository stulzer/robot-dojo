require 'pry'
require 'spec_helper'
require 'robot'

describe Robot do

  before do
    @robot = Robot.new
  end

  describe 'initial state' do

    it 'only allow a valid PLACE' do
      expect(@robot.report).to eq '0,0,NORTH'

      expect(@robot.place 0,1, 'NORTH').to eq true
      expect(@robot.report).to eq '0,1,NORTH'
    end

    it 'have a 5x5 table' do
      expect(@robot.table.height).to eq 5
      expect(@robot.table.width).to eq 5
    end

  end

  describe 'placement' do

    it 'not fall from table' do
      direction = 'NORTH'

      expect(@robot.place(0, 5, direction)).to be false
      expect(@robot.place(0,  -1, direction)).to be false
      expect(@robot.place(5, 0, direction)).to be false
      expect(@robot.place(-1, 0, direction)).to be false

      expect(@robot.report).to eq '0,0,NORTH'
    end

    it 'ignore invalid directions' do
      expect(@robot.place(0,0, 'FOO')).to be false

      expect(@robot.report).to eq '0,0,NORTH'
    end
  end

  describe 'movement' do

    describe '(ignored invalid)' do

      it 'not move off the west border' do
        @robot.place 0,0, 'WEST'
        @robot.move
        expect(@robot.report).to eq '0,0,WEST'
      end

      it 'not move off the east border' do
        @robot.place 4,0, 'EAST'
        @robot.move
        expect(@robot.report).to eq '4,0,EAST'
      end

      it 'not move off the north border' do
        @robot.place 0,4, 'NORTH'
        @robot.move
        expect(@robot.report).to eq '0,4,NORTH'
      end

      it 'not move off the south border' do
        @robot.place 0,0, 'SOUTH'
        @robot.move
        expect(@robot.report).to eq '0,0,SOUTH'
      end
    end

    describe '(valid)' do

      before do
        @robot.place 1,1,'NORTH'
      end

      it 'move WEST' do
        @robot.left
        @robot.move
        expect(@robot.report).to eq '0,1,WEST'
      end

      it 'move EAST' do
        @robot.right
        @robot.move
        expect(@robot.report).to eq '2,1,EAST'
      end

      it 'move NORTH' do
        @robot.move
        expect(@robot.report).to eq '1,2,NORTH'
      end

      it 'move SOUTH' do
        @robot.left.left
        @robot.move
        expect(@robot.report).to eq '1,0,SOUTH'
      end
    end

  end

  describe 'rotation' do

    before do
      @robot.place 0,0, 'NORTH'
    end

    it 'rotate clockwise' do
      expect(@robot.direction.name).to eq 'NORTH'

      @robot.right
      expect(@robot.direction.name).to eq 'EAST'

      @robot.right
      expect(@robot.direction.name).to eq 'SOUTH'

      @robot.right
      expect(@robot.direction.name).to eq 'WEST'

      @robot.right
      expect(@robot.direction.name).to eq 'NORTH'
    end

    it 'rotate anti-clockwise' do
      expect(@robot.direction.name).to eq 'NORTH'

      @robot.left
      expect(@robot.direction.name).to eq 'WEST'

      @robot.left
      expect(@robot.direction.name).to eq 'SOUTH'

      @robot.left
      expect(@robot.direction.name).to eq 'EAST'

      @robot.left
      expect(@robot.direction.name).to eq 'NORTH'
    end
  end

  describe 'input' do

    it 'move north' do
      @robot.handle_input 'PLACE 0,0,NORTH'
      @robot.handle_input 'MOVE'
      expect(@robot.handle_input('REPORT')).to eq '0,1,NORTH'
    end

    it 'rotate and face WEST' do
      @robot.handle_input 'PLACE 0,0,NORTH'
      @robot.handle_input 'LEFT'
      expect(@robot.handle_input('REPORT')).to eq '0,0,WEST'
    end

    it 'move and rotate multiple times' do
      @robot.handle_input 'PLACE 1,2,EAST'
      @robot.handle_input 'MOVE'
      @robot.handle_input 'MOVE'
      @robot.handle_input 'LEFT'
      @robot.handle_input 'MOVE'
      expect(@robot.handle_input('REPORT')).to eq '3,3,NORTH'
    end

    it 'discard invalid input' do
      first_place = '0,0,NORTH'

      @robot.handle_input 'NON-VALID COMMAND'
      expect(@robot.handle_input('REPORT')).to eq first_place

      @robot.handle_input 'PLACE'
      expect(@robot.handle_input('REPORT')).to eq first_place

      @robot.handle_input 'PLACE l,1,NORTH'
      expect(@robot.handle_input('REPORT')).to eq first_place

      @robot.handle_input 'PLACE 1,l,NORTH'
      expect(@robot.handle_input('REPORT')).to eq first_place

      @robot.handle_input 'PLACE 1,1,FOO'
      expect(@robot.handle_input('REPORT')).to eq first_place
    end

  end
end
