require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  test "room new functionality" do
    room = Room.new
    assert !room.save, "no name or user_id given"

    room = Room.new
    room[:name] = "name"
    assert !room.save, "no user_id given"

    room = Room.new
    room[:name] = "n"
    room[:user_id] = 1
    assert !room.save, "name too short, must be 2"

    room = Room.new
    room[:name] = "name"
    room[:user_id] = 1
    assert room.save, "name/rid ok"

    room = Room.new
    room[:name] = "name"
    room[:user_id] = 1
    room[:password] = "ohmanhopefullydoesntanyonenoticethatthispasswordiswaytoolong"
    assert !room.save, "password too long"
  end
end
