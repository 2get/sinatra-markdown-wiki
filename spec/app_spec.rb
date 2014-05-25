# coding: utf-8

require 'spec_helper'

describe 'Project::App' do

  def app
    @app ||= Project::App
  end

  describe 'when GET /' do
    before { get '/' }
    subject { last_response }

    it 'status code 200' do
      expect(subject.status).to eq(200)
    end

    it 'shows the title' do
      expect(subject.body).to match /<title>Site Title<\/title>/m
    end

    it 'shows the content' do
      expect(subject.body).to match /Hello World!/m
    end
  end

end
